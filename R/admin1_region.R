#' An R6 object for creating Administration Level 1 choropleths based on regions.
#'
#' Compare with the Admin1Choropleth object, which creates Admin 1 choropleths based on 
#' Countries. This function is useful if you want a map that spans multiple countries -
#' Especially if it only needs to include a portion of a country.
#' 
#' @export
#' @importFrom dplyr left_join
#' @importFrom R6 R6Class 
#' @include choropleth.R
Admin1RegionChoropleth = R6Class("Admin1RegionChoropleth",
  inherit = Choropleth,
  public = list(

    initialize = function(user.df)
    {
      if (!requireNamespace("choroplethrAdmin1", quietly = TRUE)) {
        stop("Package choroplethrAdmin1 is needed for this function to work. Please install it.", call. = FALSE)
      }
      
      data(admin1.map, package="choroplethrAdmin1", envir=environment())
      admin1.map = admin1.map[admin1.map$region %in% user.df$region, ]
      super$initialize(admin1.map, user.df)
      
      if (private$has_invalid_regions)
      {
        warning("Please use ?get_admin1_regions in the chroplethrAdmin1 package to get a list of mappable regions")
      }
    }
  )
)

#' Create a map of Administrative Level 1 regions
#' 
#' Unlike ?admin1_choropleth, the regions here can span multiple countries.
#'
#' The map used comes from ?admin1.map in the choroplethrAdmin1 package. See ?get_admin_countries
#' and ?get_admin_regions in the choroplethrAdmin1 package for help with the spelling of regions.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in ?admin1.regions
#' in the choroplethrAdmin1 package
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param num_colors The number of colors on the map. A value of 1 
#' will use a continuous scale. A value in [2, 9] will use that many colors. 
#' @param zoom An optional vector of regions to zoom in on. Elements of this vector must exactly 
#' match the names of regions as they appear in the "region" column of ?admin1.regions.
#' @param reference_map If true, render the choropleth over a reference map from Google Maps.
#' @examples
#' \dontrun{
#' 
#' library(choroplethrAdmin1)
#'
#' # map of continental us + southern canada
#'  
#' data("continental_us_states")
#' lower_canada = c("british columbia", "alberta", "saskatchewan", "manitoba", "ontario", "quebec")
#' regions = c(lower_canada, continental_us_states)
#' df = data.frame(region=regions, value=sample(1:length(regions)))
#' 
#' admin1_region_choropleth(df) 
#'
#' }
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer ggplotGrob annotation_custom 
#' @importFrom scales comma
#' @importFrom grid unit grobTree
admin1_region_choropleth = function(df, title="", legend="", num_colors=7, zoom=NULL, reference_map=FALSE)
{
  if (!requireNamespace("choroplethrAdmin1", quietly = TRUE)) {
    stop("Package choroplethrAdmin1 is needed for this function to work. Please install it.", call. = FALSE)
  }
  c = Admin1RegionChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_num_colors(num_colors)
  c$set_zoom(zoom)
  if (reference_map) {
    c$render_with_reference_map()
  } else {
    c$render()
  }
}