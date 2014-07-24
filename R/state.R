# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("state.map", "county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

state_clip = function(df, states)
{
  # remove anything not a state in the 50 states
  df$region = normalize_state_names(df$region)
  choroplethr.state.names = tolower(state.name)
  df = df[df$region %in% choroplethr.state.names, ]
  
  # now remove anything outside the list of states the user wants to render
  df[df$region %in% normalize_state_names(states), ]
}

#' @importFrom plyr rename join
state_bind = function(df, warn_na = TRUE)
{
  stopifnot(c("region", "value") %in% colnames(df))
 
  df$region = normalize_state_names(df$region)
  
  data(state.map, package="choroplethr", envir=environment())
  state_map_df = state.map
  state_map_df$region = tolower(state_map_df$region)
  
  choropleth = join(state_map_df, df, by="region", type="left")
  missing_states = unique(choropleth[is.na(choropleth$value), ]$region)
  # while the map contains Washington, DC, choroplethr does not support it because it 
  # is not in state.abb and is not technically a state.
  missing_states = setdiff(missing_states, "district of columbia")
  if (warn_na && length(missing_states) > 0)
  {
    missing_states = paste(missing_states, collapse = ", ");
    warning_string = paste("The following regions were missing and are being set to NA:", missing_states);
    print(warning_string);
  }

  choropleth = choropleth[order(choropleth$order), ];
  choropleth
}
                                                                          choropleth_scale
state_render_helper = function(choropleth.df, scaleName, theme, min, max, choropleth_scale)
{
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      scale_fill_continuous(scaleName, labels=comma, na.value="black", limits=c(min, max)) + # use a continuous scale
      theme;
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9

    if (is.null(choropleth_scale))
    {
      choropleth_scale = get_default_discrete_scale(scaleName)
    }
      
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      choropleth_scale +  # scale_fill_brewer(scaleName, drop=FALSE, labels=comma, na.value="black") + # use discrete scale for buckets
      theme;
  }   
}

#' @importFrom ggplot2 ggplotGrob annotation_custom
#' @importFrom grid grobTree 
state_render = function(choropleth.df, title, scaleName, showLabels, states, renderAsInsets, scale)
{
  # only show the states the user asked
  choropleth.df = choropleth.df[choropleth.df$region %in% normalize_state_names(states), ]
  
  # if user requested to render all 50 states, 
  # create separate data.frames for AK and HI and render them as separate images
  # cache min, max value of entire data.frame to make scales consistent between all 3 images
  min_val = 0
  max_val = 0
  if (is.numeric(choropleth.df$value))
  {
    min_val = min(choropleth.df$value)
    max_val = max(choropleth.df$value)
  }
  
  if (states == state.abb && renderAsInsets)
  {
    # subset AK and render it
    alaska.df     = choropleth.df[choropleth.df$region=='alaska',]
    alaska.ggplot = state_render_helper(alaska.df, scaleName, theme_inset(), min_val, max_val, choropleth_scale=scale)    
    alaska.grob   = ggplotGrob(alaska.ggplot)
    
    # subset HI and render it
    hawaii.df     = choropleth.df[choropleth.df$region=='hawaii',]
    hawaii.ggplot = state_render_helper(hawaii.df, scaleName, theme_inset(), min_val, max_val, choropleth_scale=scale)
    hawaii.grob   = ggplotGrob(hawaii.ggplot)

    # remove AK and HI from the "real" df
    choropleth.df = choropleth.df[!choropleth.df$region %in% c("alaska", "hawaii"), ]
  }
  
  choropleth = state_render_helper(choropleth.df, scaleName, theme_clean(), min_val, max_val, choropleth_scale=scale) + ggtitle(title)
  
  if (states == state.abb && renderAsInsets)
  {
    choropleth = choropleth + 
      annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
      annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)    
  }

  # let's assume that people who want labels don't need them for AK and HI
  if (showLabels) {
      df_state_labels = data.frame(long = state.center$x, lat = state.center$y, label = state.abb)
      df_state_labels = df_state_labels[!df_state_labels$label %in% c("AK", "HI"), ]
      df_state_labels = df_state_labels[df_state_labels$label %in% states, ]
      choropleth = choropleth + geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
  }
 
  choropleth
}

#' Create a choropleth of US States
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Region must contain state names or abbreviations (e.g. "California" or "CA").  
#' @param title An optional title for the map.  
#' @param scaleName An optional label for the legend.
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets.  For
#' example, 2 will show values above or below the median, and 9 will show the maximum
#' resolution.
#' @param warn_na If true, choroplethr will emit a warning when a) you give it regions that it is ignoring and b) you do not supply regions that it is rendering.
#' @param states A vector of states to render.  Defaults to state.abb.
#' @param showLabels For state choropleths, whether or not to show state abbreviations on the map.
#' Defaults to T. 
#' @param renderAsInsets If true, Alaska and Hawaii will be rendered as insets on the map.  If false, all 50 states will be rendered
#' on the same longitude and latitude map to scale. This variable is only checked when the "states" variable is equal to all 50 states.
#' @return A choropleth.
#' 
#' @keywords choropleth
#' 
#' @examples
#' data(choroplethr)
#'
#' # 2012 US Presidential results
#' state_choropleth(df_president, title="2012 US Presidential Results")
#'
#' # 2012 state population estimates - continuous vs. discrete scale
#' state_choropleth(df_pop_state, num_buckets=1, title="2012 State Population Estimates")
#' state_choropleth(df_pop_state, num_buckets=9, title="2012 State Population Estimates") 
#' 
#' @export
#' @seealso \code{\link{state.map}} which contains information about the state map and \code{\link{state.names}} which contains the names of the regions in the map.
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom plyr arrange rename
#' @importFrom scales comma
#' @importFrom Hmisc cut2
state_choropleth = function(df, 
                            title          = "", 
                            scaleName      = "",
                            num_buckets    = 7, 
                            warn_na        = FALSE,
                            states         = state.abb,
                            showLabels     = TRUE,
                            renderAsInsets = TRUE,
                            scale          = NULL)
{
  df = state_clip(df, states) # remove elements we won't be rendering
  df = discretize(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = state_bind(df, warn_na) # bind df to map
  state_render(choropleth.df, title, scaleName, showLabels, states, renderAsInsets, scale) # render map
}