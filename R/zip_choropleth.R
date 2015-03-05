#' An R6 object for creating ZIP-level choropleths.
#' @export
#' @importFrom dplyr left_join
#' @importFrom R6 R6Class
#' @include choropleth.R
ZipChoropleth = R6Class("ZipChoropleth",
  inherit = Choropleth,
  public = list(
    
    # initialize with a ZIP map
    initialize = function(user.df)
    {
      if (!requireNamespace("choroplethrZip", quietly = TRUE)) {
        stop("Package choroplethrZip is needed for this function to work. Please install it.", call. = FALSE)
      }
      
      data(zip.map, package="choroplethrZip", envir=environment())
      super$initialize(zip.map, user.df)
      
      if (private$has_invalid_regions)
      {
        warning("Please see ?zip.regions for a list of mappable regions")
      }
    }
  )
)

#' Create a zip-level choropleth
#' 
#' The map used is zip.map in the choroplethrZip package. See zip.regions for
#' an object which can help you coerce your regions into the required format.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in ?zip.map.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional vector of countries to zoom in on. Elements of this vector must exactly 
#' match the names of countries as they appear in the "region" column of ?zip.regions.
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer ggplotGrob annotation_custom 
#' @importFrom scales comma
#' @importFrom grid unit grobTree
zip_choropleth = function(df, title="", legend="", buckets=7, zoom=NULL)
{
  c = ZipChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_buckets(buckets)
  c$set_zoom(zoom)
  c$render()
}
