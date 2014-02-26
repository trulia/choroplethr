#' Bind a data.frame to a map
#' 
#' Given a data.frame which contains (region, value) pairs, bind it to either a state, county
#' or ZIP code map.  The result can then be rendered by calling render_choropleth.
#'  
#' @param df A data.frame with one column named "region" and one column named "value".
#' @param lod A string representing the level of detail of the map you want.  Must be one of "state",
#' "county" or "zip".
#' @param states a vector of postal codes representing US states.  Defaults to state.abb.
#' 
#' @return A data.frame.
#' @seealso \code{\link{render_choropleth}}.
#' @export
bind_df_to_map = function(df, lod, states=state.abb)
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