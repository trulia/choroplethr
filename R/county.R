all_county_choropleth = function(df, num_buckets=9, title="", scaleName="")
{
  stopifnot(c("region", "value") %in% colnames(df))
  df = rename(df, replace=c("region" = "fips"))
  
  # add fips column to county maps
  # this is the maps data
  county.df = map_data("county");
  names(county.df)[5:6] = c("state","county")
  county.df$polyname = paste(county.df$state, county.df$county, sep = ",");
  data(county.fips, package="maps", envir = environment())
  
  
  # county.fips handles non-contiguous counties by adding eg ":main" to the end.
  # however, map_data does follow this convention.  In order to merge properly
  # remove the : and everything after
  county.fips.2 = county.fips;
  county.fips.2$polyname = as.character(county.fips.2$polyname);
  split_names = strsplit(county.fips.2$polyname,":");
  county.fips.2$polyname = unlist(lapply(split_names, "[", 1));
  county.fips.2$polyname = as.factor(county.fips.2$polyname);
  county.fips.2 = unique(county.fips.2);
  
  county.df = merge(county.df, county.fips.2); 
  
  # new we can merge our data with the map data, because the map data now has fips codes
  choropleth = merge(county.df, df, all = T);
  if (any(is.na(choropleth$value)))
  {
    missing_polynames = unique(choropleth[is.na(choropleth$value), ]$polyname);
    missing_polynames = paste(missing_polynames, collapse = ", ");
    warning_string    = paste("The following counties were missing and are being set to 0:", missing_polynames);
    print(warning_string);
    choropleth$value[is.na(choropleth$value)] = 0;
  }
  
  # add state boundaries
  state.df   = map_data("state");
  choropleth = choropleth[order(choropleth$order), ];
  
  # how many buckets should I use?
  if (num_buckets > 1)
  {
    choropleth$value = generate_values(choropleth$value, num_buckets);
    
    ggplot(choropleth, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_brewer(scaleName, labels=comma) + # use discrete scale for buckets
      ggtitle(title) +
      theme_clean();
  } else {
    ggplot(choropleth, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_continuous(scaleName, labels=comma) + # use a continuous scale
      ggtitle(title) +
      theme_clean();
  }
}