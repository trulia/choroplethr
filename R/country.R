#' An R6 object for creating country-level choropleths.
#' @export
#' @importFrom dplyr left_join
#' @importFrom R6 R6Class
#' @include choropleth.R
CountryChoropleth = R6Class("CountryChoropleth",
  inherit = Choropleth,
  public = list(
    
    # initialize with a world map
    initialize = function(user.df)
    {
      if (!requireNamespace("choroplethrMaps", quietly = TRUE)) {
        stop("Package choroplethrMaps is needed for this function to work. Please install it.", call. = FALSE)
      }

      data(country.map, package="choroplethrMaps", envir=environment())
      super$initialize(country.map, user.df)
      
      if (private$has_invalid_regions)
      {
        warning("Please see ?country.regions for a list of mappable regions")
      }
    }
  )
)

#' Create a country-level choropleth
#' 
#' The map used is country.map in the choroplethrMaps package. See country.regions for
#' an object which can help you coerce your regions into the required format.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in ?country.map.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param num_colors The number of colors to use on the map.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many colors. 
#' @param zoom An optional vector of countries to zoom in on. Elements of this vector must exactly 
#' match the names of countries as they appear in the "region" column of ?country.regions
#' @examples
#' # demonstrate default options
#' data(df_pop_country)
#' country_choropleth(df_pop_country, "2012 World Bank Populate Estimates")
#'
#' # demonstrate continuous scale
#' country_choropleth(df_pop_country, "2012 World Bank Populate Estimates", num_colors=1)
#'
#' # demonstrate zooming
#' country_choropleth(df_pop_country, 
#'                    "2012 World Bank Population Estimates", 
#'                    num_colors=1,
#'                    zoom=c("united states of america", "canada", "mexico"))

#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer ggplotGrob annotation_custom 
#' @importFrom scales comma
#' @importFrom grid unit grobTree
country_choropleth = function(df, title="", legend="", num_colors=7, zoom=NULL)
{
  c = CountryChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_num_colors(num_colors)
  c$set_zoom(zoom)
  c$render()
}
