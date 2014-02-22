# This is unfortunately necessary to have R CMD CHECK not throw out spurious NOTEs when using ggplot2
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
  df = bind_df_to_state_map(df, states)
  
  # bucket values if necessary
  if (num_buckets > 1)
  {
    df$value = generate_values(df$value, num_buckets);
  }
  
  choropleth = generate_base_state_choropleth(df)

  if (num_buckets > 1)
  {
    choropleth = choropleth +
      scale_fill_brewer(scaleName, labels=comma); # use brewer discrete scale
  } else {
    choropleth = choropleth +
      scale_fill_continuous(scaleName, labels=comma); # use a continuous scale
  }
  
  if (showLabels)
  {
    choropleth = choropleth + add_state_labels(choropleth)
  }
  
  choropleth
}

generate_base_state_choropleth = function(choropleth_df, num_buckets)
{
  choropleth_df = arrange(choropleth_df, group, order);
  ggplot(choropleth_df, aes(x = long, y = lat, group = group)) + 
    geom_polygon(aes(fill = value), color = "black") +
    ggtitle(title) +
    theme_clean()  
}

bind_df_to_state_map = function(df, states)
{
  df$region     = normalize_state_names(df$region)
  state_map_df  = subset_map("state", states)
  choropleth_df = merge(state_map_df, df)
  
  if (any(is.na(choropleth_df$value)))
  {
    missing_states = unique(choropleth_df[is.na(choropleth_df$value), ]$region);
    missing_states = paste(missing_states, collapse = ", ");
    warning_string = paste("The following regions were missing and are being set to 0:", missing_states);
    print(warning_string);
    choropleth_df$value[is.na(choropleth$value)] = 0;
  }
  choropleth_df
}

add_state_labels = function()
{
  df_state_labels = data.frame(long = state.center$x, lat = state.center$y, label = state.abb);
  df_state_labels = df_state_labels[!df_state_labels$label %in% c("AK", "HI"), ];
  df_state_labels = df_state_labels[df_state_labels$label %in% states, ];

  geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
}