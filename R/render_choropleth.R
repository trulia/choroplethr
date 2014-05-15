#' Render a choropleth
#' 
#' Given a data.frame which contains map data and value data, render it as a choropleth using ggplot2.
#'  
#' @param choropleth.df A data.frame with a column named "region" and a column named "value".  If lod is "state" 
#' then region must contain state names (e.g. "California" or "CA").  If lod is "county" then region must  
#' contain county FIPS codes.  if lod is "zip" then region must contain 5 digit ZIP codes.
#' @param lod A string representing the level of detail of your data.  Must be one of "state",
#' "county" or "zip".
#' @param title The title of the image.  Defaults to "".
#' @param scaleName The name of the scale/legend.  Default to "".
#' @param showLabels For State maps, whether or not to show labels of the states.
#' @param states A vector of states to render.  Defaults to state.abb.
#' @param renderAsInsets If true, Alaska and Hawaii will be rendered as insets on the map.  If false, all 50 states will be rendered
#' on the same longitude and latitude map to scale. This variable is only checked when the "states" variable is equal to all 50 states.

#' Defaults to state.abb.
#' 
#' @seealso \code{\link{get_acs_df}} and \code{\link{bind_df_to_map}}
#' @return A choropleth.
#' @export
#' @examples
#' data(choroplethr)
#' library(Hmisc) # for cut2
#' 
#' # States with greater than 1M residents
#' df.map = bind_df_to_map(df_pop_state, "state")
#' df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
#' render_choropleth(df.map, "state", "States with a population over 1M", "Population")
#'
#' # Counties with greater than or greater than 1M residents
#' df.map = bind_df_to_map(df_pop_county, "county")
#' df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
#' render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")
#' 
#' # Zip Code Tabulated Areas with less than 1000 people
#' df_pop_zip = df_pop_zip[df_pop_zip$value < 1000, ]
#' df.map = bind_df_to_map(df_pop_zip, "zip")
#' render_choropleth(df.map, "zip", "ZCTAs with less than 1000 people in California", states="CA")
render_choropleth = function(choropleth.df, lod, title="", scaleName="", showLabels=TRUE, states=state.abb, renderAsInsets=TRUE)
{
  stopifnot("value" %in% colnames(choropleth.df))
  stopifnot(lod %in% c("state", "county", "zip"))
  
  if (lod == "state") {
    render_state_choropleth(choropleth.df, title, scaleName, showLabels, states, renderAsInsets)
  } else if (lod == "county") {
    render_county_choropleth(choropleth.df, title, scaleName, states)
  } else if (lod == "zip") {
    render_zip_choropleth(choropleth.df, title, scaleName, states)
  }
}