#' Bind a data.frame to a map
#' 
#' Given a data.frame which contains (region, value) pairs, bind it to either a state, county
#' or ZIP code map.  The result can then be rendered by calling render_choropleth.  The value 
#' column is copied to a column named value.bak to facilitate user experimentation with various 
#' visualization strategies.
#'  
#' @param df A data.frame with one column named "region" and one column named "value".
#' @param lod A string representing the level of detail of the map you want.  Must be one of "state",
#' "county" or "zip".
#' 
#' @return A data.frame.
#' @seealso \code{\link{get_acs_df}} and \code{\link{render_choropleth}}.
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
bind_df_to_map = function(df, lod)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(lod %in% c("state", "county", "zip"))
  
  df = df[, c("region", "value")]
  df$value.bak = df$value

  if (lod == "state") {
    bind_df_to_state_map(df)
  } else if (lod == "county") {
    bind_df_to_county_map(df)
  } else if (lod == "zip") {
    bind_df_to_zip_map(df)
  }
}