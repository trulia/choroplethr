#' An R6 object for creating Administration Level 1 choropleths.
#' @export
#' @importFrom dplyr left_join
#' @importFrom R6 R6Class 
#' @importFrom choroplethrMaps get_admin1_map
#' @include choropleth.R
Admin1Choropleth = R6Class("Admin1Choropleth",
  inherit = Choropleth,
  public = list(
    
    # initialize with a map of the country
    initialize = function(country.name, user.df)
    {
      admin1.map = get_admin1_map(country.name)
      super$initialize(admin1.map, user.df)
      
      if (private$has_invalid_regions)
      {
        warning("Please see ?country.regions for a list of mappable regions")
      }
    }
  )
)

#' Create an admin1-level choropleth for a specified country
#' 
#' The map used comes from ?admin1.map in the choroplethrMaps package. See ?get_admin_countries
#' and ?get_admin_regions in the choroplethrMaps package for help with the spelling of regions.
#' 
#' @param country.name The name of the country. Must exactly match how the country is named in the "country"
#' column of ?admin1.regions in the choroplethrMaps package.
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in ?admin1.regions
#' in the choroplethrMaps package
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional vector of regions to zoom in on. Elements of this vector must exactly 
#' match the names of regions as they appear in the "region" column of ?admin1.regions.

#' @examples
#' \dontrun{
#' 
#' data(df_japan_census)
#' head(df_japan_census)
#' # set the value we want to map to be the 2010 population estimates
#' df_japan_census$value=df_japan_census$pop_2010
#' 
#' # default map of all of japan
#' admin1_choropleth("japan", 
#'                    df_japan_census, 
#'                    "2010 Japan Population Estimates", 
#'                    "Population")
#' 
#' # zoom in on the Kansai region and use a continuous scale
#' kansai = c("mie", "nara", "wakayama", "kyoto", "osaka", "hyogo", "shiga")
#' admin1_choropleth("japan", 
#'                    df_japan_census, 
#'                    "2010 Japan Population Estimates", 
#'                    "Population", 
#'                    1, 
#'                    kansai)
#' }
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer ggplotGrob annotation_custom 
#' @importFrom scales comma
#' @importFrom grid unit grobTree
admin1_choropleth = function(country.name, df, title="", legend="", buckets=7, zoom=NULL)
{
  c = Admin1Choropleth$new(country.name, df)
  c$title  = title
  c$legend = legend
  c$set_buckets(buckets)
  c$set_zoom(zoom)
  c$render()
}