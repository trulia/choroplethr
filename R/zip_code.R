#' Create a US ZIP-level data map
#' 
#' Note that this map is not technically a choropleth because it does not draw
#' boundaries of the ZIP codes. The ZIP codes are rendered as a scatterplot.
#' @export
#' @importFrom dplyr left_join
ZipMap = R6Class("ZipMap",
   inherit = USAChoropleth,
   
   public = list(
     # initialize with us state map
     initialize = function(user.df)
     {
       data(zipcode)
       # all choropleths need a column named region
       zipcode$region = zipcode$zip
       # USAChoropleth requires a column called "state" that has full lower case state name (e.g. "new york")
       zipcode$state.abb = zipcode$state
       zipcode$state = tolower(state.name[match(zipcode$state, state.abb)])

       super$initialize(zipcode, user.df)
     }    
   )
)


#' Create a data map of USA ZIPs with sensible defaults.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  
#' @param title An optional title for the map.  
#' @param legend_name An optional name for the legend.  
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' 
#' @examples
#' data(df_pop_zip)
#' zip_map(df_pop_zip, title="US 2012 Population Estimates", legend_name="Population")
#'
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit

zip_map = function(df, title="", legend_name="", num_buckets=7)
{
  c = ZipMap$new(df)
  c$title       = title
  c$legend_name = legend_name
  
  c$render(num_buckets)
}
