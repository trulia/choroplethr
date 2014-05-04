# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

bind_df_to_state_map = function(df)
{
  stopifnot(c("region", "value") %in% colnames(df))
 
  df$region = normalize_state_names(df$region)
  state_map_df = map_data("state")
  
  choropleth = merge(state_map_df, df, all.x=TRUE)
  
  if (any(is.na(choropleth$value)))
  {
    missing_states = unique(choropleth[is.na(choropleth$value), ]$region);
    missing_states = paste(missing_states, collapse = ", ");
    warning_string = paste("The following regions were missing and are being set to NA:", missing_states);
    print(warning_string);
  }

  choropleth = choropleth[order(choropleth$order), ];
  choropleth
}

render_state_choropleth = function(choropleth.df, title="", scaleName="", showLabels=TRUE, states=state.abb)
{
  # only show the states the user asked
  choropleth.df = choropleth.df[choropleth.df$region %in% normalize_state_names(states), ]
  
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

  if (showLabels) {
      df_state_labels = data.frame(long = state.center$x, lat = state.center$y, label = state.abb)
      df_state_labels = df_state_labels[!df_state_labels$label %in% c("AK", "HI"), ]
      df_state_labels = df_state_labels[df_state_labels$label %in% states, ]
      choropleth = choropleth + geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
  }
 
  choropleth
}

state_choropleth_auto = function(df, 
                            num_buckets = 9, 
                            title = "", 
                            showLabels = T,
                            scaleName = "",
                            states)
{
  df = clip_df(df, "state", states) # remove elements we won't be rendering
  df = discretize_df(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = bind_df_to_state_map(df) # bind df to map
  render_state_choropleth(choropleth.df, title, scaleName, showLabels, states) # render map
}
