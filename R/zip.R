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