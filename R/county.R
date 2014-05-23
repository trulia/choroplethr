# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

#' @importFrom plyr rename join
bind_df_to_county_map = function(df)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(class(df$region) %in% c("character", "numeric", "integer"))

  df$region = as.numeric(df$region)
  df = rename(df, replace=c("region" = "county.fips.numeric"))
  
  data(map.counties, package="choroplethr", envir=environment())
  choropleth = join(map.counties, df, by="county.fips.numeric", type="left")
  if (any(is.na(choropleth$value)))
  {
    missing_polynames = unique(choropleth[is.na(choropleth$value), ]$polyname);
    missing_polynames = paste(missing_polynames, collapse = ", ");
    warning_string    = paste("The following counties were missing and are being set to NA:", missing_polynames);
    print(warning_string);
  }

  choropleth = choropleth[order(choropleth$order), ];
  
  choropleth
}

render_county_choropleth = function(choropleth.df, title="", scaleName="", states=state.abb)
{
  # only show the states the user asked
  choropleth.df = choropleth.df[choropleth.df$STATE %in% get_state_fips_from_abb(states), ]
  
  # county maps really need state backgrounds
  state.df = subset_map("state", states);
  
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_continuous(scaleName, labels=comma, na.value="black") + # use a continuous scale
      ggtitle(title) +
      theme_clean();
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9

    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_brewer(scaleName, labels=comma, na.value="black") + # use discrete scale for buckets
      ggtitle(title) +
      theme_clean();
  }
}

# this needs to be called from the main choroplethr function
county_choropleth_auto = function(df, num_buckets, title, scaleName, states, renderAsInsets)
{
  df = clip_df(df, "county", states) # remove elements we won't be rendering
  df = discretize_df(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = bind_df_to_county_map(df) # bind df to map
  render_county_choropleth(choropleth.df, title, scaleName, states) # render map
}