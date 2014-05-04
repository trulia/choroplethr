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
#' "county" or "zip".
#' @param states A list of states to subset. Must be a subset of state.abb.
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
clip_df = function(df, lod, states=state.abb)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(states %in% state.abb) # states must be valid abbreviations
  stopifnot("region" %in% colnames(df))
  
  if (lod == "state") {
    clip_df_state(df, states)
  } else if (lod == "county") {
    clip_df_county(df, states)
  } else {
    clip_df_zip(df, states)
  }
}

clip_df_state = function(df, states)
{
  # remove anything not a state in the lower 48
  df$region = normalize_state_names(df$region)
  choroplethr.state.names = setdiff(tolower(state.name), c("alaska", "hawaii"))
  df = df[df$region %in% choroplethr.state.names, ]
  
  # now remove anything outside the list of states the user wants to render
  df[df$region %in% normalize_state_names(states), ]
}

county_fips_has_valid_state = function(county.fips, vector.of.valid.state.fips)
{
  # technically a county fips should always be 5 characters, but in practice people often
  # drop the leading 0. See http://en.wikipedia.org/wiki/FIPS_county_code
  ret = logical(0)
  
  for (fips in county.fips)
  {
    stopifnot(nchar(fips) == 4 || nchar(fips) == 5)
    if (nchar(fips) == 4) {
      state = substr(fips, 1, 1)
    } else {
      state = substr(fips, 1, 2)
    }
    
    ret = c(ret, state %in% vector.of.valid.state.fips)
  }
  
  ret
}

clip_df_county = function(df, states)
{
  # if someone gives us county fips codes with leading 0's, remove them.
  # although leading 0's are correct, the maps package, which we bind to, does not use that convention.
  if (is.factor(df$region))
  {
    df$region = as.character(df$region)
  }  
  if (is.character(df$region))
  {
    df$region = as.numeric(df$region)
  }    
    
  # See ?county.fips. These codes are (intentionally) missing Alaska and Hawaii
  data(county.fips, package="maps", envir=environment())
  df = df[(df$region %in% county.fips$fips), ]
  
  data(state.fips, package="maps", envir=environment())
  state.fips.to.render = unique(state.fips[state.fips$abb %in% states, "fips"])

  df[county_fips_has_valid_state(df$region, state.fips.to.render), ]
}

clip_df_zip = function(df, states)
{
  # list of all zips in listed states
  data(zipcode, package="zipcode", envir=environment())
  zipcode = zipcode[zipcode$state %in% states, ]

  df[df$region %in% zipcode$zip, ]
}