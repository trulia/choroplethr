bind_df_to_world_map = function(df)
{
# Comment this out for now - it's just WIP for a world map. 
# We'll need to put in our own world map later, because the one that ggplot2's map_data
# gets is so old that it contains the USSR, which means that we basically can't make
# choropleths of modern data.
  
#  stopifnot(c("region", "value") %in% colnames(df))
 
#  df$region = normalize_state_names(df$region)
#  world_map_df # = map_data("world")
  
#  choropleth = merge(world_map_df, df, all.x=TRUE)
  
#  if (any(is.na(choropleth$value)))
#  {
#    missing_countries = unique(choropleth[is.na(choropleth$value), ]$region);
#    missing_countries = paste(missing_countries, collapse = ", ");
#    warning_string = paste("The following regions were missing and are being set to NA:", missing_countries);
#    print(warning_string);
#  }

#  choropleth = choropleth[order(choropleth$order), ];
#  choropleth
}

render_world_choropleth = function(choropleth.df, title="", scaleName="")
{
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    choropleth = ggplot(choropleth.df, aes(long, lat, group = group)) +
                     geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
                     scale_fill_continuous(scaleName, labels=comma, na.value="black") + # use a continuous scale
                     ggtitle(title) +
                     theme_clean();
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9

    choropleth = ggplot(choropleth.df, aes(long, lat, group = group)) +
                     geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
                     scale_fill_brewer(scaleName, labels=comma, na.value="black") + # use discrete scale for buckets
                     ggtitle(title) +
                     theme_clean();
  } 
 
  choropleth
}

world_choropleth_auto = function(df, 
                            num_buckets = 9, 
                            title = "", 
                            scaleName = "")
{
  df = clip_df(df, "world") # remove elements we won't be rendering
  df = discretize_df(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = bind_df_to_world_map(df) # bind df to map
  render_world_choropleth(choropleth.df, title, scaleName) # render map
}