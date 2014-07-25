# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("state.names", "county.map", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

county_fips_has_valid_state = function(county.fips, vector.of.valid.state.fips)
{
  # technically a county fips should always be 5 characters, but in practice people often
  # drop the leading 0. See http://en.wikipedia.org/wiki/FIPS_county_code
  ret = logical(0)
  
  for (fips in county.fips)
  {
    stopifnot(nchar(fips) == 4 || nchar(fips) == 5)
    if (nchar(fips) == 4) {
      state = substr(fips, 1, 1)
    } else {
      state = substr(fips, 1, 2)
    }
    ret = c(ret, state %in% vector.of.valid.state.fips)
  }
  
  ret
}

county_clip = function(df, states)
{
  # if someone gives us county fips codes with leading 0's, remove them.
  # although leading 0's are correct, some people do not use them.  It is easier to 
  # convert to numeric than character - converting to numeric is not ambiguous.
  if (is.factor(df$region))
  {
    df$region = as.character(df$region)
  }  
  if (is.character(df$region))
  {
    df$region = as.numeric(df$region)
  }    
  
  # remove values that are not on our map at all
  data(county.map, package="choroplethr", envir=environment())
  df = df[df$region %in% county.map$county.fips.numeric, ]
  
  data(state.names, package="choroplethr", envir=environment())
  state.fips.to.render = state.names[state.names$abb %in% states, "fips.numeric"]
  
  df[county_fips_has_valid_state(df$region, state.fips.to.render), ]
}

#' @importFrom plyr rename join
county_bind = function(df, warn_na = TRUE)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(class(df$region) %in% c("character", "numeric", "integer"))

  df$region = as.numeric(df$region)
  df = rename(df, replace=c("region" = "county.fips.numeric"))
  
  data(county.map, package="choroplethr", envir=environment())
  choropleth = join(county.map, df, by="county.fips.numeric", type="left")
  missing_fips = unique(choropleth[is.na(choropleth$value), ]$county.fips);
  # county FIPS code 11001 is Washington DC, which choroplethr currently does not support
  # because it is not part of state.abb. However, it's in the map so it always triggers a warning
  missing_fips = setdiff(missing_fips, "11001") 
  if (warn_na && length(missing_fips) > 0)
  {
    missing_fips = paste(missing_fips, collapse = ", ");
    warning_string = paste("The following counties were missing and are being set to NA:", missing_fips);
    print(warning_string);
  }

  choropleth = choropleth[order(choropleth$order), ];
  
  choropleth
}

county_render_helper = function(choropleth.df, state.df, scaleName, theme, min, max)
{
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_continuous(scaleName, labels=comma, na.value="black") + # use a continuous scale
      theme;
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
    
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_brewer(scaleName, labels=comma, na.value="black") + # use discrete scale for buckets
      theme;
  }
}

county_render = function(choropleth.df, title, scaleName, states, renderAsInsets, scale)
{
  # only show the states the user asked
  choropleth.df = choropleth.df[choropleth.df$STATE %in% get_state_fips_from_abb(states), ]
  
  # county maps really need state backgrounds
  state.df = subset_map("state", states);
  
  # if user requested to render all 50 states, 
  # create separate data.frames for AK and HI and render them as separate images
  # cache min, max value of entire data.frame to make scales consistent between all insets s
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
    alaska.df       = choropleth.df[choropleth.df$STATE==get_state_fips_from_abb("AK"), ]
    alaska.state.df = choropleth.df[choropleth.df$region=='alaska',]

    alaska.ggplot = county_render_helper(alaska.df, alaska.state.df, "", theme_inset(), min_val, max_val)    
    alaska.grob   = ggplotGrob(alaska.ggplot)
    
    # subset HI and render it
    hawaii.df       = choropleth.df[choropleth.df$STATE==get_state_fips_from_abb("HI"), ]
    hawaii.state.df = choropleth.df[choropleth.df$region=='hawaii',]
    
    hawaii.ggplot = county_render_helper(hawaii.df, hawaii.state.df, "", theme_inset(), min_val, max_val)
    hawaii.grob   = ggplotGrob(hawaii.ggplot)
    
    # remove AK and HI from the "real" df
    choropleth.df = choropleth.df[!choropleth.df$STATE %in% get_state_fips_from_abb(c("AK", "HI")), ]
    state.df      = state.df[!state.df$region %in% c("alaska", "hawaii"),]
  }
  
  choropleth = county_render_helper(choropleth.df, state.df, scaleName, theme_clean(), min_val, max_val) + ggtitle(title)
  
  if (states == state.abb && renderAsInsets)
  {
    choropleth = choropleth + 
      annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
      annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)    
  }
  
  choropleth
}

#' Create a choropleth of US Counties
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Region must contain county FIPS codes.  
#' @param title An optional title for the map.  
#' @param scaleName An optional label for the legend.
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets.  For
#' example, 2 will show values above or below the median, and 9 will show the maximum
#' resolution.
#' @param warn_na If true, choroplethr will emit a warning when a) you give it regions that it is ignoring and b) you do not supply regions that it is rendering.
#' @param states A vector of states to render.  Defaults to state.abb.
#' @param renderAsInsets If true, Alaska and Hawaii will be rendered as insets on the map.  If false, all 50 states will be rendered
#' on the same longitude and latitude map to scale. This variable is only checked when the "states" variable is equal to all 50 states.
#' @param scale an optional ggplot2 scale to use. For example "scale_fill_brewer(palette=2)".
#' @return A choropleth.
#' 
#' @keywords choropleth
#' 
#' @examples
#' data(choroplethr)
#'
#' # 2012 county population estimates - continuous vs. discrete scale
#' county_choropleth(df_pop_county, num_buckets=1, title="2012 County Population Estimates")
#' county_choropleth(df_pop_county, num_buckets=9, title="2012 County Population Estimates") 
#' 
#' @export
#' @seealso \code{\link{county.map}} which contains information about the county map and \code{\link{county.names}} which contains the names of the regions in the map.

#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom plyr arrange rename
#' @importFrom scales comma
#' @importFrom Hmisc cut2
county_choropleth = function(df, 
                             title          = "", 
                             scaleName      = "", 
                             num_buckets    = 7,
                             warn_na        = FALSE,
                             states         = state.abb, 
                             renderAsInsets = TRUE,
                             scale          = NULL)
{
  df = county_clip(df, states) # remove elements we won't be rendering
  df = discretize(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = county_bind(df, warn_na) # bind df to map
  county_render(choropleth.df, title, scaleName, states, renderAsInsets, scale) # render map
}