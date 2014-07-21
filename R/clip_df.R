if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("state.names"))
}
#' Clip a data.frame to a map
#'
#' Given a data.frame and a lod, remove elements from the data.frame which will not appear in the map. This is useful if you want to do a statistical analysis
#' on the data.frame based on how it will appear in the map.  For example, choroplethr currently does not display Alaska or Hawaii. So if you want to report on the median
#' value in a data set, and have the map reflect your analysis, you should first call this function on the data.frame.  It is the first function call in choroplethr().
#'  
#' @param df A data.frame with a column named "region".  If lod is "state" 
#' then region must contain state names (e.g. "California" or "CA").  If lod is "county" then region must  
#' contain county FIPS codes.  if lod is "zip" then region must contain 5 digit ZIP codes.
#' @param lod A string representing the level of detail of the map you want.  Must be one of "state",
#' "county", "zip" or "world.
#' @param states A list of states to subset. Must be a subset of state.abb.
#' @param countries A list of countries to subset. Used only for the world map. Must be a subset of country.names.
#' 
#' @return A data.frame.
#' @export
#' @examples
#' data(choroplethr)
#' library(Hmisc) # for cut2
#' 
#' data(choroplethr)
#' nrow(df_pop_state) # 52
#' new_df = clip_df(df_pop_state, "state")
#' nrow(new_df) # 48
#'
#' nrow(df_pop_county) # 3221
#' new_df = clip_df(df_pop_county, "county")
#' nrow(new_df) # 3074
#' 
#' nrow(df_pop_zip) # 33120
#' new_df = clip_df(df_pop_zip, "zip")
#' nrow(new_df) # 32936
clip_df = function(df, lod, states=state.abb, countries=NULL)
{
  stopifnot(lod %in% c("world", "state", "county", "zip", "world"))
  stopifnot(states %in% state.abb) # states must be valid abbreviations
  stopifnot("region" %in% colnames(df))
  
  if (lod == "world") {
    clip_df_world(df, countries)
  } else if (lod == "state") {
    clip_df_state(df, states)
  } else if (lod == "county") {
    clip_df_county(df, states)
  } else {
    clip_df_zip(df, states)
  }
}

clip_df_world = function(df, countries)
{
  data(country.names, package="choroplethr", envir=environment())
  stopifnot(countries %in% country.names$region)
  stopifnot(!any(duplicated(countries)))
  
  df = df[df$region %in% countries, ]
  df
}

clip_df_zip = function(df, states)
{
  # list of all zips in listed states
  data(zipcode, package="zipcode", envir=environment())
  zipcode = zipcode[zipcode$state %in% states, ]

  df[df$region %in% zipcode$zip, ]
}