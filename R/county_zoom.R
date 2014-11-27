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
     },
    
    render = function()
    {
      if (length(private$zoom) > 1)
      {
        super$render()
      } else {
        self$prepare_map()
        
        ggplot(self$choropleth.df, aes(long, lat, group = group)) +
          geom_path(color = "black", size = 1) + 
          self$theme_clean() + 
          ggtitle(self$title)  
      }      
    }
   )
)

#' Create a choropleth of USA Counties, with sensible defaults, that zooms on counties.
#' 
#' The map used is county.map in the choroplethrMaps package.  See country.regions
#' in the choroplethrMaps package for an object which can help you coerce your regions
#' into the required format. If you zoom in on a single county, only an outline of the 
#' county is shown.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in county.map.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  Ignored if zooming in on a single county.
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. Ignored if 
#' zooming in on a single county.
#' @param zoom An optional vector of counties to zoom in on. Elements of this vector must exactly 
#' match the names of counties as they appear in the "region" column of ?county.regions.
#' 
#' @examples
#' \dontrun{
#' 
#' library(choroplethrMaps)
#' data(county.regions)
#'
#' library(dplyr)
#' 
#' # show the population of the 5 counties (boroughs) that make up New York City
#' nyc_county_names=c("kings", "bronx", "new york", "queens", "richmond")
#' nyc_county_fips = county.regions %>%
#'   filter(state.name=="new york" & county.name %in% nyc_county_names) %>%
#'   select(region)
#' county_zoom_choropleth(df_pop_county, 
#'                        title="Population of Counties in New York City",
#'                        legend="Population",
#'                        buckets=1,
#'                        zoom=nyc_county_fips$region)
#'                        
#' # zooming in on a single county shows just an outline.
#' county_zoom_choropleth(df_pop_county,
#'                        title="Zoom of Manhattan",
#'                        zoom=36061) # manhattan
#'                        
#' # population of the 9 counties in the san francisco bay area
#' bay_area_county_names = c("alameda", "contra costa", "marin", "napa", "san francisco", 
#'                           "san mateo", "santa clara", "solano", "sonoma")
#' bay_area_county_fips = county.regions %>%
#'   filter(state.name=="california" & county.name %in% bay_area_county_names) %>%
#'   select(region)
#' county_zoom_choropleth(df_pop_county, 
#'                        title="Population of Counties in the San Francisco Bay Area",
#'                        legend="Population",
#'                        buckets=1,
#'                        zoom=bay_area_county_fips$region)                        
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
