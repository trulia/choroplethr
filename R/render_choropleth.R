#' Render a choropleth
#' 
#' Given a data.frame which contains map data and value data, render it as a choropleth using ggplot2.
#'  
#' @param choropleth.df A data.frame with one column named "region" and one column named "value".  The variable is 
#' normally the output of bind_df_to_map.
#' @param lod A string representing the level of detail of the map you want.  Must be one of "state",
#' "county" or "zip".
#' @param title The title of the image.  Defaults to "".
#' @param scaleName the name of the scale/legend.  Default to "".
#' @param showLabels for State maps, whether or not to show labels of the states.
#' @param states a vector of postal codes representing US states.  Defaults to state.abb.
#' 
#' @seealso \code{\link{bind_df_to_map}}
#' @return A data.frame.
#' @export
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