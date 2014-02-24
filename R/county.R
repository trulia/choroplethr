if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("county.fips", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

#' Create a choropleth
#' 
#' Creates a choropleth from a specified data.frame and level of detail.
#'
#' @param df A data.frame with a column named "region" and a column named "value"
#' @param lod A string indicating the level of detail of the map.  Must be "state", "county" or "zip".
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets.  For
#' example, 2 will show values above or below the median, and 9 will show the maximum
#' resolution.  Defaults to 9.
#' @param title A title for the map.  Defaults to "".
#' @param scaleName An optional label for the legend.  Defaults to "".
#' @param showLabels For state choropleths, whether or not to show state abbreviations on the map.
#' Defaults to T. 
#' @param states A vector of states to render.  Defaults to state.abb.
#' @return A choropleth
#' 
#' @keywords choropleth
#' 
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous map_data scale_colour_brewer
#' @importFrom plyr arrange rename
#' @importFrom scales comma
#' @importFrom Hmisc cut2
#' 
#' @seealso \code{\link{choroplethr_acs}} which generates choropleths from Census tables.


# TODO: Rename return value choropleth.df
#' @export
bind_df_to_county_map = function(df, states = state.abb)
{
  stopifnot(c("region", "value") %in% colnames(df))
  df = rename(df, replace=c("region" = "fips"))
    
  # add fips column to county maps
  county.df = subset_map("county", states)
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
  choropleth = merge(county.df, df);
  if (any(is.na(choropleth$value)))
  {
    missing_polynames = unique(choropleth[is.na(choropleth$value), ]$polyname);
    missing_polynames = paste(missing_polynames, collapse = ", ");
    warning_string    = paste("The following counties were missing and are being set to 0:", missing_polynames);
    print(warning_string);
    choropleth$value[is.na(choropleth$value)] = 0;
  }

  choropleth = choropleth[order(choropleth$order), ];
  
  choropleth
}

#' @export
render_county_choropleth = function(choropleth.df, title="", scaleName="", states=state.abb)
{
  # county maps really need state backgrounds
  state.df = subset_map("state", states);
  
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_continuous(scaleName, labels=comma) + # use a continuous scale
      ggtitle(title) +
      theme_clean();
  } else if (is.factor(choropleth.df$value)) {
    stopifnot(length(levels(choropleth.df$value)) <= 9) # brewer scale only goes up to 9

    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_brewer(scaleName, labels=comma) + # use discrete scale for buckets
      ggtitle(title) +
      theme_clean();
  } else {
    stop("value needs to be numeric or factor")
  }
}

# this needs to be called from the main choroplethr function
county_choropleth_auto = function(df, num_buckets=9, title="", scaleName="", states=state.abb)
{
  choropleth.df = bind_df_to_county_map(df, states)
  choropleth.df$value = discretize_values(choropleth.df$value, num_buckets);
  render_county_choropleth(choropleth.df, title, scaleName, states)
}