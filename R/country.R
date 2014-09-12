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
      data(country.map)
      super$initialize(country.map, user.df)
    }
  )
)

#' Create a country-level choropleth
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  
#' @param title An optional title for the map.  
#' @param legend_name An optional name for the legend.  
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional list of countries to zoom in on. Must come from the "name" column in
#' ?country.names

#' @examples
#' data(df_pop_country)
#' country_choropleth(df_pop_country, "2012 World Bank Populate Estimates")
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer ggplotGrob annotation_custom 
#' @importFrom scales comma
#' @importFrom grid unit grobTree
country_choropleth = function(df, title="", legend_name="", num_buckets=7, zoom=NULL)
{
  c = CountryChoropleth$new(df)
  c$title       = title
  c$legend_name = legend_name
  c$set_num_buckets(num_buckets)
  if (!is.null(zoom))
  {
    c$set_zoom(zoom)
  }
  c$render()
}
