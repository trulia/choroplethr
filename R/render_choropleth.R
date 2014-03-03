#' Render a choropleth
#' 
#' Given a data.frame which contains map data and value data, render it as a choropleth using ggplot2.
#'  
#' @param choropleth.df A data.frame with one column named "region" and one column named "value".  The variable is 
#' normally the output of bind_df_to_map.
#' @param lod A string representing the level of detail of your data.  Must be one of "state",
#' "county" or "zip".
#' @param title The title of the image.  Defaults to "".
#' @param scaleName The name of the scale/legend.  Default to "".
#' @param showLabels For State maps, whether or not to show labels of the states.
#' @param states A vector of postal codes representing US states.  Defaults to state.abb.
#' 
#' @seealso \code{\link{get_acs_df}} and \code{\link{bind_df_to_map}}
#' @return A data.frame.
#' @export
#' @examples
#' \dontrun{
#' library(Hmisc) # for cut2
#' # States with greater than 1M residents
#' df     = get_acs_df("B01003", "state") # population
#' df.map = bind_df_to_map(df, "state")
#' df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
#' render_choropleth(df.map, "state", "States with a population over 1M", "Population")
#'
#' # Counties with greater than or greater than 1M residents
#' df     = get_acs_df("B01003", "county") # population
#' df.map = bind_df_to_map(df, "county")
#' df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
#' render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")
#' 
#' # ZIP codes in California where median age is between 20 and 30
#' df       = get_acs_df("B01002", "zip") # median age
#' df       = df[df$value >= 20 & df$value <= 30, ]
#' df$value = cut2(df$value, g=3) # 3 equally-sized groups
#' df.map   = bind_df_to_map(df, "zip")
#' render_choropleth(df.map, 
#'                  "zip", 
#'                  title = "CA Zip Codes by Age",
#'                  scaleName = "Median Age",
#'                  states = "CA") 
#' }
render_choropleth = function(choropleth.df, lod, title="", scaleName="", showLabels=TRUE, states=state.abb)
{
  stopifnot("value" %in% colnames(choropleth.df))
  stopifnot(lod %in% c("state", "county", "zip"))
  
  if (lod == "state") {
    render_state_choropleth(choropleth.df, title, scaleName, showLabels, states)
  } else if (lod == "county") {
    render_county_choropleth(choropleth.df, title, scaleName, states)
  } else if (lod == "zip") {
    render_zip_choropleth(choropleth.df, title, scaleName, states)
  }
}