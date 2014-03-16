#' Bind a data.frame to a map
#' 
#' Given a data.frame which contains (region, value) pairs, bind it to either a state, county
#' or ZIP code map.  The result can then be rendered by calling \code{\link{render_choropleth}}.  The value 
#' column is copied to a column named value.bak to facilitate user experimentation with various 
#' visualization strategies.  This workflow gives you more control over output than \code{\link{choroplethr}}.
#'  
#' @param df A data.frame with a column named "region" and a column named "value".  If lod is "state" 
#' then region must contain state names (e.g. "California" or "CA").  If lod is "county" then region must  
#' contain county FIPS codes.  if lod is "zip" then region must contain 5 digit ZIP codes.
#' @param lod A string representing the level of detail of the map you want.  Must be one of "state",
#' "county" or "zip".
#' 
#' @return A data.frame.
#' @seealso \code{\link{get_acs_df}} and \code{\link{render_choropleth}}.
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