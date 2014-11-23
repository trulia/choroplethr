#' Create a county-level choropleth that zooms on counties, not states.
#' @export
#' @importFrom dplyr left_join
#' @include usa.R
CountyZoomChoropleth = R6Class("CountyZoomChoropleth",
  inherit = Choropleth,
   
  public = list(
    # initialize with us state map
    initialize = function(user.df)
    {
      data(county.map, package="choroplethrMaps", envir=environment())
      data(county.regions, package="choroplethrMaps", envir=environment())
      super$initialize(county.map, user.df)
       
      # by default, show all counties on the map
      private$zoom = unique(county.map$region)
       
      if (private$has_invalid_regions)
      {
        warning("Please see ?county.regions for a list of mappable regions")
      }
     }     
   )
)

#' Create a choropleth of USA Counties, with sensible defaults, that zooms on counties.
#' 
#' The map used is county.map in the choroplethrMaps package.  See country.regions
#' in the choroplethrMaps package for an object which can help you coerce your regions
#' into the required format.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in county.map.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional vector of states to zoom in on. Elements of this vector must exactly 
#' match the names of states as they appear in the "region" column of ?state.regions.
#' 
#' @examples
#' \dontrun{
#' 
#' # show the population of the 5 counties (boroughs) that make up New York City.
#' 
#' nyc_fips=c(36005, 36047, 36081, 36061, 36085)
#'  county_zoom_choropleth(df_pop_county, 
#'                         zoom=nyc_fips, 
#'                         buckets=1, 
#'                         title="Population of Counties in New York City",
#'                         scale="Population")
#' }
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit
county_zoom_choropleth = function(df, title="", legend="", buckets=7, zoom=NULL)
{
  c = CountyZoomChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_buckets(buckets)
  c$set_zoom(zoom)
  c$render()
}
