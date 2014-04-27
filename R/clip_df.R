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

clip_df_county = function(df, states)
{
  
}

clip_df_zip = function(df, states)
{
  
}