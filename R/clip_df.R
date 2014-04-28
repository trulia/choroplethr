# given a df, remove elements which we will not render
# for example, we don't render Alaska, Hawaii
clip_df = function(df, lod, states)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(states %in% state.abb) # states must be valid abbreviations
  
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