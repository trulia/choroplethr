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
    },
    
    # All zooms, at the end of the day, are zip zooms. But often times it is more natural
    # for users to specify the zoom in other geographical units
    set_zoom = function(zip_zoom=NULL, county_zoom=NULL, state_zoom=NULL, msa_zoom=NULL)
    {
      # user must zoom by exactly one of the options
      num_zooms_selected = sum(!is.null(c(zip_zoom, county_zoom, state_zoom, msa_zoom)))
      if (num_zooms_selected == 0) {
        stop("Full zip choropleths are not supported. Please select one of zip_zoom, county_zoom, state_zoom or msa_zoom")
      } else if (num_zooms_selected > 1) {
        stop("You can only zoom in by one of zip_zoom, county_zoom, state_zoom or msa_zoom")
      }
      
      data(zip.regions, package="choroplethrZip", envir=environment())
      
      # if no zooms selected, or if the zip_zoom field is selected, just do default behavior
      if (num_zooms_selected == 0 || !is.null(zip_zoom)) {
        super$set_zoom(zip_zoom)
      # if county_zoom field is selected, extract zips from counties  
      } else if (!is.null(county_zoom)) {
          stopifnot(all(county_zoom %in% unique(zip.regions$county.fips.numeric)))
          zips = zip.regions[zip.regions$county.fips.numeric %in% county_zoom, "region"]
          super$set_zoom(zips)        
      } else if (!is.null(state_zoom)) {
        stopifnot(all(state_zoom %in% unique(zip.regions$state.name)))
        zips = zip.regions[zip.regions$state.name %in% state_zoom, "region"]
        super$set_zoom(zips)        
      } else if (!is.null(msa_zoom)) {
        stopifnot(all(msa_zoom %in% unique(zip.regions$cbsa.title)))
        zips = zip.regions[zip.regions$cbsa.title %in% msa_zoom, "region"]
        super$set_zoom(zips)                
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
#' @param zip_zoom An optional vector of zip codes to zoom in on. Elements of this vector must exactly 
#' match the names of zips as they appear in the "region" column of ?zip.regions.
#' @param county_zoom An optional vector of county FIPS codes to zoom in on. Elements of this 
#' vector must exactly match the names of zips as they appear in the "county.fips.numeric" column 
#' of ?zip.regions.
#' @param state_zoom An optional vector of State names to zoom in on. Elements of this 
#' vector must exactly match the names of the state names as they appear in the "state.name" column 
#' of ?zip.regions.
#' @param msa_zoom An optional vector of MSA (Metroplitan/Micropolitan Statistical Area) names to zoom in on. Elements of this 
#' vector must exactly match the names of the state names as they appear in the "cbsa.title" column 
#' of ?zip.regions.
#'
#' @examples
#' \dontrun{
#' library(choroplethrZip)
#' data(df_pop_zip)
#' ?df_pop_zip
#'
#' # demonstrate zooming on a state
#' zip_choropleth(df_pop_zip, state_zoom="new york")
#' 
#' # demonstrate viewing on a set of counties
#' # note we use numeric county FIPS codes
#' nyc_fips = c(36005, 36047, 36061, 36081, 36085)
#' zip_choropleth(df_pop_zip, county_zoom=nyc_fips)
#'
#' # demonstrate zooming in on an msa
#' zip_choropleth(df_pop_zip, msa_zoom="New York-Newark-Jersey City, NY-NJ-PA")
#'
#' # demonstrate zooming in on a few ZIPs
#' manhattan_zips=c("10001", "10002", "10003", "10004", "10005", "10006", "10007")
#' zip_choropleth(df_pop_zip, zip_zoom=manhattan_zips)
#' 
#' }
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer ggplotGrob annotation_custom 
#' @importFrom scales comma
#' @importFrom grid unit grobTree
zip_choropleth = function(df, title="", legend="", buckets=7, zip_zoom=NULL, county_zoom=NULL, state_zoom=NULL, msa_zoom=NULL)
{
  c = ZipChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_buckets(buckets)
  c$set_zoom(zip_zoom, county_zoom, state_zoom, msa_zoom)
  c$render()
}
