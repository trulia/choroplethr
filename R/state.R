# This is unfortunately necessary to have R CMD not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

state_choropleth = function(df, 
                            num_buckets = 9, 
                            title = "", 
                            showLabels = T,
                            scaleName = "",
                            states)
{
  df$region = normalize_state_names(df$region)
  state_map_df = subset_map("state", states)
  
  choropleth = merge(state_map_df, df)
  
  if (any(is.na(choropleth$value)))
  {
    missing_states = unique(choropleth[is.na(choropleth$value), ]$region);
    missing_states = paste(missing_states, collapse = ", ");
    warning_string = paste("The following regions were missing and are being set to 0:", missing_states);
    print(warning_string);
    choropleth$value[is.na(choropleth$value)] = 0;
  }
  
  # how many buckets should I use?
  if (num_buckets > 1)
  {
    choropleth$value = generate_values(choropleth$value, num_buckets);
    
    choropleth = arrange(choropleth, group, order);
    choropleth = ggplot(choropleth, aes(x = long, y = lat, group = group)) + 
                    geom_polygon(aes(fill = value), color = "black") +
                    scale_fill_brewer(scaleName, labels=comma) + # use brewer discrete scale
                    ggtitle(title) +
                    theme_clean();
  } else {
    choropleth = arrange(choropleth, group, order);
    choropleth = ggplot(choropleth, aes(x = long, y = lat, group = group)) + 
                    geom_polygon(aes(fill = value), color = "black") +
                    scale_fill_continuous(scaleName, labels=comma) + # use a continuous scale
                    ggtitle(title) +
                    theme_clean();
  }
  
  if (showLabels)
  {
    df_state_labels = data.frame(long = state.center$x, lat = state.center$y, label = state.abb);
    df_state_labels = df_state_labels[!df_state_labels$label %in% c("AK", "HI"), ];
    df_state_labels = df_state_labels[df_state_labels$label %in% states, ];
    choropleth = choropleth + 
      geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
  }
  
  choropleth
}
