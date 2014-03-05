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
#' 
#' @export
#' @examples
#' # a state choropleth
#' df = data.frame(region=state.abb, value=sample(100, 50))
#' choroplethr(df, lod="state")
#'
#' # a county choropleth
#' data(county.fips, package="maps")
#' df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=TRUE))
#' choroplethr(df, "county", 2)
#' 
#' # a zip choropleth 
#' data(zipcode, package="zipcode", envir=environment())
#' df = data.frame(region=zipcode$zi, value = sample(100, nrow(zipcode), replace=TRUE))
#' choroplethr(df, "zip", 9)
choroplethr = function(df, 
                       lod, 
                       num_buckets = 9, 
                       title = "", 
                       scaleName = "",
                       showLabels = T,
                       states = state.abb)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(num_buckets > 0 && num_buckets < 10)
  
  # states shouldn't be duplicated, and must be entered as valid postal codes
  stopifnot(states %in% state.abb)
  stopifnot(!any(duplicated(states)))
  
  states = states[!states %in% c("AK", "HI")] # for now, only render lower 48 states

  df = df[, c("region", "value")] # prevent naming collision from merges later on
  
  if (lod == "state") {
    state_choropleth_auto(df, num_buckets, title, showLabels, scaleName, states);
  } else if (lod == "county") {
    county_choropleth_auto(df, num_buckets, title, scaleName, states)
  } else if (lod == "zip") {
    zip_choropleth_auto(df, num_buckets, title, scaleName, states)
  }
}