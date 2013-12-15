all_zip_choropleth = function(df, 
                                num_buckets = 9, 
                                title = "", 
                                roundLabel = T,
                                scaleName = "")
{
  stopifnot(c("region", "value") %in% colnames(df))
  df = rename(df, replace=c("region" = "zip"))
    
  data(zipcode) # from library(zipcode)
  choropleth = merge(zipcode, df, all.x=F, all.y=T);

  # only print contiguous 48 states now, mostly for conformity with state and county maps,
  # where the limitation is technical
  choropleth = choropleth[choropleth$state %in% state.abb
                    & !choropleth$state %in% c("AK", "HI"), ]
  # remove 2 points of bad data in the zipcode package.
  # it has two zips in NY and VA in the atlantic/europe
  choropleth = choropleth[choropleth$longitude < -10, ]   
  
  # add an outline for states.  rename columns for consistency
  state_map_df = map_data("state");
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