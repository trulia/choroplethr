# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("map.states", "county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

#' @importFrom plyr rename join
bind_df_to_state_map = function(df, warn_na = TRUE)
{
  stopifnot(c("region", "value") %in% colnames(df))
 
  df$region = normalize_state_names(df$region)
  
  data(map.states, package="choroplethr", envir=environment())
  state_map_df = map.states
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

print_state_choropleth = function(choropleth.df, scaleName, theme, min, max)
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
    
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      scale_fill_brewer(scaleName, drop=FALSE, labels=comma, na.value="black") + # use discrete scale for buckets
      theme;
  }   
}

#' @importFrom ggplot2 ggplotGrob annotation_custom
#' @importFrom grid grobTree 
render_state_choropleth = function(choropleth.df, title="", scaleName="", showLabels=TRUE, 
                                   states=state.abb, renderAsInsets)
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
    alaska.ggplot = print_state_choropleth(alaska.df, "", theme_inset(), min_val, max_val)    
    alaska.grob   = ggplotGrob(alaska.ggplot)
    
    # subset HI and render it
    hawaii.df     = choropleth.df[choropleth.df$region=='hawaii',]
    hawaii.ggplot = print_state_choropleth(hawaii.df, "", theme_inset(), min_val, max_val)
    hawaii.grob   = ggplotGrob(hawaii.ggplot)

    # remove AK and HI from the "real" df
    choropleth.df = choropleth.df[!choropleth.df$region %in% c("alaska", "hawaii"), ]
  }
  
  choropleth = print_state_choropleth(choropleth.df, scaleName, theme_clean(), min_val, max_val) + ggtitle(title)
  
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

state_choropleth_auto = function(df, 
                            num_buckets = 9, 
                            title = "", 
                            showLabels = T,
                            scaleName = "",
                            states,
                            renderAsInsets,
                            warn_na)
{
  df = clip_df(df, "state", states) # remove elements we won't be rendering
  df = discretize_df(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = bind_df_to_state_map(df, warn_na) # bind df to map
  render_state_choropleth(choropleth.df, title, scaleName, showLabels, states, renderAsInsets) # render map
}
