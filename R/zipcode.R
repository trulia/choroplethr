# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

bind_df_to_zip_map = function(df)
{
  stopifnot(c("region", "value") %in% colnames(df))
  df = rename(df, replace=c("region" = "zip"))
  
  data(zipcode, package="zipcode", envir=environment()) 
  choropleth = merge(zipcode, df, all.x=F, all.y=T);
  
  # only print contiguous 48 states now, mostly for conformity with state and county maps,
  # where the limitation is technical
  choropleth = choropleth[choropleth$state %in% state.abb
                          & !choropleth$state %in% c("AK", "HI"), ]
  # remove 2 points of bad data in the zipcode package.
  # it has two zips in NY and VA in the atlantic/europe
  choropleth = choropleth[choropleth$longitude < -10, ]
}

render_zip_choropleth = function(choropleth.df, title="", scaleName="", states=state.abb)
{
  # only render the states the user requested
  choropleth.df = choropleth.df[choropleth.df$state %in% states, ]
  
  # add an outline for states.  rename columns for consistency
  state_map_df = subset_map("state", states);
  colnames(state_map_df)[names(state_map_df) == "long"] = "longitude"
  colnames(state_map_df)[names(state_map_df) == "lat"]  = "latitude"
  state_map_df = arrange(state_map_df, group, order);
  
  if (is.numeric(choropleth.df$value))
  {    
    ggplot(choropleth.df, aes(x=longitude, y=latitude,color=value)) + 
      geom_point() + 
      ggtitle(title) +
      theme_clean() + 
      scale_color_continuous(scaleName, labels=comma) +
      geom_polygon(data = state_map_df, color = "black", fill = NA, aes(group=group));
    
  } else { # assume character or factor
    stopifnot(length(unique(choropleth.df$value)) <= 9) # brewer scale only goes up to 9
    
    ggplot(choropleth.df, aes(x=longitude, y=latitude,color=value)) + 
      geom_point() + 
      scale_colour_brewer(scaleName, labels=comma) +
      ggtitle(title) +
      theme_clean() + 
      geom_polygon(data = state_map_df, color = "black", fill = NA, aes(group=group));
  }
}

#' @importFrom ggplot2 geom_point scale_color_continuous
zip_choropleth_auto = function(df, num_buckets = 9, title = "", scaleName = "", states)
{
  df = clip_df(df, "zip", states) # remove elements we won't be rendering
  df = discretize_df(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = bind_df_to_zip_map(df) # bind df to map
  render_zip_choropleth(choropleth.df, title, scaleName, states) # render map
}