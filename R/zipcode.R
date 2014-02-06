# This is unfortunately necessary to have R CMD not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

#' @importFrom ggplot2 geom_point scale_color_continuous
zip_choropleth = function(df, num_buckets = 9, title = "", scaleName = "", states)
{
  stopifnot(c("region", "value") %in% colnames(df))
  df = rename(df, replace=c("region" = "zip"))
    
  data(zipcode, package="zipcode", envir=environment()) 
  choropleth = merge(zipcode, df, all.x=F, all.y=T);

  # only print contiguous 48 states now, mostly for conformity with state and county maps,
  # where the limitation is technical
  choropleth = choropleth[choropleth$state %in% states
                    & !choropleth$state %in% c("AK", "HI"), ]
  # remove 2 points of bad data in the zipcode package.
  # it has two zips in NY and VA in the atlantic/europe
  choropleth = choropleth[choropleth$longitude < -10, ]   
  
  # add an outline for states.  rename columns for consistency
  state_map_df = subset_map("state", states);
  colnames(state_map_df)[names(state_map_df) == "long"] = "longitude"
  colnames(state_map_df)[names(state_map_df) == "lat"]  = "latitude"
  state_map_df = arrange(state_map_df, group, order);
    
  # how many buckets should I use?
  if (num_buckets > 1)
  {
    choropleth$value = generate_values(choropleth$value, num_buckets);
    
    ggplot(choropleth, aes(x=longitude, y=latitude,color=value)) + 
      geom_point() + 
      scale_colour_brewer(scaleName, labels=comma) +
      ggtitle(title) +
      theme_clean() + 
      geom_polygon(data = state_map_df, color = "black", fill = NA, aes(group=group));
  } else {
    ggplot(choropleth, aes(x=longitude, y=latitude,color=value)) + 
      geom_point() + 
      ggtitle(title) +
      theme_clean() + 
      scale_color_continuous(labels=comma) +
      geom_polygon(data = state_map_df, color = "black", fill = NA, aes(group=group));
  }
} 