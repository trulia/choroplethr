normalize_state_names = function(state_names)
{
  if (is.factor(state_names))
  {
    state_names = as.character(state_names)
  }
  
  if (is.character(state_names))
  {
    if (all(nchar(state_names) == 2))
    {
      state_names = toupper(state_names) # "Ny" -> "NY"
      state_names = tolower(state.name[match(state_names, state.abb)])
    } else {      
      # otherwise assume "New York", "new york", etc.
      state_names = tolower(state_names);
    }
  }
  
  # TODO: handle FIPS codes for states
  # fips codes are integers (at least in state.fips$fips), which might be a bug since technically
  # they should have leading 0's.
  # TODO: emit warnings for states that are not present
  
  state_names;
}

all_state_choropleth = function(df, 
                                num_buckets = 9, 
                                title = "", 
                                showLabels = T,
                                scaleName = "")
{
  df$region = normalize_state_names(df$region)
  state_map_df = ggplot2::map_data("state");
  choropleth = merge(state_map_df, df, all = T)
  
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
    df_state_labels = subset(df_state_labels, !state.abb %in% c("AK", "HI"));
    
    choropleth = choropleth + 
      geom_text(data = df_state_labels, aes(long, lat, label = label,group = NULL), color = 'black')
  }
  
  choropleth
}
