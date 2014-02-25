#' Render a choropleth
#' 
#' Given a data.frame which contains map data and value data, render it as a map using ggplot2.
#'  
#' @param choropleth.df A data.frame with one column named "region" and one column named "value".  The variable is 
#' normally the output of \link{\code{bind_df_to_map}}.
#' @param lod A string representing the level of detail of the map you want.  Must be one of "state",
#' "county" or "zip".
#' @param title The title of the image.  Defaults to "".
#' @param scaleName the name of the scale/legend.  Default to "".
#' @param states a vector of postal codes representing US states.  Defaults to state.abb.
#' 
#' @return A data.frame.
#' @export
render_choropleth = function(choropleth.df, lod, title="", scaleName="", labelSates=TRUE, states=state.abb)
{
  stopifnot("value" %in% colnames(choropleth.df))
  stopifnot("lod" %in% c("state", "county", "zip"))
  
  if (lod == "state") {
    render_state_choropleth(choropleth.df, title="", scaleName="", showLabels, states=state.abb)
  } else if (lod == "county") {
    render_county_choropleth(choropleth.df, title="", scaleName="", states=state.abb)
  } else if (lod == "zip") {
    render_zip_choropleth(choropleth.df, title="", scaleName="", states=state.abb)
  }
}