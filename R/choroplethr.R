# lod is the level of detail
choroplethr = function(df, 
                       lod, 
                       num_buckets = 9, 
                       title = "", 
                       roundLabel = T,
                       scaleName = "",
                       showLabels = T)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(num_buckets > 0 && num_buckets < 10)

  df = df[, c("region", "value")] # prevent naming collision from merges later on
  
  if (lod == "state")
  {
    all_state_choropleth(df, num_buckets, title, roundLabel, showLabels, scaleName);
  } else if (lod == "county") {
    all_county_choropleth(df, num_buckets, title, roundLabel, scaleName)
  } else if (lod == "zip") {
    all_zip_choropleth(df, num_buckets, title, roundLabel, scaleName)
  }
}