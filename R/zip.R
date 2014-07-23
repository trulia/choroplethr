# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

zip_clip = function(df, states)
{
  # list of all zips in listed states
  data(zipcode, package="zipcode", envir=environment())
  zipcode = zipcode[zipcode$state %in% states, ]
  
  df[df$region %in% zipcode$zip, ]
}

zip_bind = function(df)
{
  stopifnot(c("region", "value") %in% colnames(df))
  df = rename(df, replace=c("region" = "zip"))
  
  data(zipcode, package="zipcode", envir=environment()) 
  choropleth = merge(zipcode, df, all.x=F, all.y=T);
  
  # remove 2 points of bad data in the zipcode package.
  # it has two zips in NY and VA in the atlantic/europe
  choropleth = choropleth[choropleth$longitude < -10, ]
}

#' @importFrom plyr arrange
zip_render_helper = function(choropleth.df, states, scaleName, theme, min, max)
{
  stopifnot(states %in% state.abb)
  
  state.df = subset_map("state", states)
  colnames(state.df)[names(state.df) == "long"] = "longitude"
  colnames(state.df)[names(state.df) == "lat"]  = "latitude"
  state.df = arrange(state.df, group, order);
  
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    ggplot(choropleth.df, aes(x=longitude, y=latitude, color=value)) +
      geom_point() +
      scale_color_continuous(scaleName, labels=comma) +
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2, aes(group=group)) + # outline for states
      theme;
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
    
    ggplot(choropleth.df, aes(x=longitude, y=latitude, color=value)) +
      geom_point() + 
      scale_colour_brewer(scaleName, labels=comma) +
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2, aes(group=group)) + # outline for states
      theme;  
  }   
}

zip_render = function(choropleth.df, title="", scaleName="", states=state.abb, renderAsInsets=TRUE)
{  
  # only render the states the user requested
  choropleth.df = choropleth.df[choropleth.df$state %in% states, ]
  
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
  
  # check lengths to avoid this wierd warning message re recycling
  # "longer object length is not a multiple of shorter object length"
  if (length(states) == length(state.abb) &&
        states == state.abb && 
        renderAsInsets)
  {
    # subset AK and render it
    alaska.df     = choropleth.df[choropleth.df$state=="AK",]
    alaska.ggplot = zip_render_helper(alaska.df, "AK", "", theme_inset(), min_val, max_val)    
    alaska.grob   = ggplotGrob(alaska.ggplot)
    
    # subset HI and render it
    hawaii.df     = choropleth.df[choropleth.df$state=="HI",]
    hawaii.ggplot = zip_render_helper(hawaii.df, "HI", "", theme_inset(), min_val, max_val)
    hawaii.grob   = ggplotGrob(hawaii.ggplot)
    
    # remove AK and HI from the "real" df
    choropleth.df = choropleth.df[!choropleth.df$state %in% c("AK", "HI"), ]
    choropleth = zip_render_helper(choropleth.df, setdiff(state.abb, c("AK", "HI")), scaleName, theme_clean(), min_val, max_val) + ggtitle(title)
    
    choropleth = choropleth + 
      annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
      annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)    
    
  } else {
    choropleth = zip_render_helper(choropleth.df, states, scaleName, theme_clean(), min_val, max_val) + ggtitle(title)    
  }
  
  choropleth
}

#' Create a colored scatterplot, with state borders, of US ZIP codes 
#' 
#' While the function is named zip_choropleth for the same of consistency with other functions in choropleth, the
#' output is not technically a choropleth map because the borders of the ZIP codes are not drawn.
#'
#' @param df A data.frame with a column named "region" and a column named "value".  Region must 5 digit zipcodes as defined in the "zipcode" package.
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
#' @return A choropleth.
#' 
#' @examples
#' library(zipcode)
#' data(zipcode)
#' head(zipcode)
#'
#' df = data.frame(region=zipcode$zip, value=sample.int(nrow(zipcode)))
#' zip_choropleth(df)
#' 
#' @seealso The "zipcode" package
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom plyr arrange rename
#' @importFrom scales comma
#' @importFrom Hmisc cut2
#' @importFrom ggplot2 geom_point scale_color_continuous
#' @export
zip_choropleth = function(df, 
                          title          = "", 
                          scaleName      = "", 
                          num_buckets    = 7, 
                          warn_na        = FALSE,
                          states         = state.abb, 
                          renderAsInsets = TRUE)
{
  df = zip_clip(df, states) # remove elements we won't be rendering
  df = discretize(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = zip_bind(df) # bind df to map
  zip_render(choropleth.df, title, scaleName, states, renderAsInsets) # render map
}