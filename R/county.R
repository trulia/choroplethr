#' Create a county-level choropleth
#' @export
#' @importFrom dplyr left_join
#' @include usa.R
CountyChoropleth = R6Class("CountyChoropleth",
  inherit = USAChoropleth,
  
  public = list(
    # this map looks better with an outline of the states added
    add_state_outline = TRUE, 
    
    # initialize with us state map
    initialize = function(user.df)
    {
      data(county.map)
      data(county.names)
      # USAChoropleth requires a column called "state" that has full lower case state name (e.g. "new york")
      county.map$state = merge(county.map, county.names, sort=FALSE, by.x="region", by.y="county.fips.numeric")$state.name
      super$initialize(county.map, user.df)
      
      # by default, show all states on the map
      data(state.map)
      private$zoom = unique(state.map$region)
      
      if (private$has_invalid_regions)
      {
        warning("Please see ?county.names for a list of mappable regions")
      }
      
    },
    
    # user.df has county FIPS codes for regions, but subsetting happens at the state level
    clip = function() 
    {
      # remove regions not on the map before doing the merge
      self$user.df = self$user.df[self$user.df$region %in% county.names$county.fips.numeric, ]
      
      data(county.names, package="choroplethr")
      self$user.df$state = merge(self$user.df, county.names, sort=FALSE, all=TRUE, by.x="region", by.y="county.fips.numeric")$state.name
      self$user.df = self$user.df[self$user.df$state %in% private$zoom, ]
      self$user.df$state = NULL
        
      self$map.df  = self$map.df[self$map.df$state %in% private$zoom, ]
    }
  )
)


#' Create a choropleth of USA Counties with sensible defaults.
#' 
#' The map used is ?county.map.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in ?county.map.
#' See ?county.names for an object which can help you coerce your regions into the required format.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional vector of states to zoom in on. Elements of this vector must exactly 
#' match the names of states as they appear in the "region" column of ?state.names.
#' 
#' @examples
#' # demonstrate default parameters - visualization using 7 equally sized buckets
#' data(df_pop_county)
#' county_choropleth(df_pop_county, title="US 2012 County Population Estimates", legend="Population")
#'
#'#' # demonstrate continuous scale and zoom
#' data(df_pop_county)
#' county_choropleth(df_pop_county, 
#'                  title="US 2012 County Population Estimates", 
#'                  legend="Population", 
#'                  buckets=1, 
#'                  zoom=c("california", "oregon", "washington"))
#'
#' # demonstrate how choroplethr handles character and factor values
#' # demonstrate user creating their own discretization of the input
#' data(df_pop_county)
#' df_pop_county$str = ""
#' for (i in 1:nrow(df_pop_county))
#' {
#'   if (df_pop_county[i,"value"] < 1000000)
#'   {
#'     df_pop_county[i,"str"] = "< 1M"
#'   } else {
#'     df_pop_county[i,"str"] = "> 1M"
#'   }
#' }
#' df_pop_county$value = df_pop_county$str
#' county_choropleth(df_pop_county, title="Which counties have more than 1M people?")

#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit
county_choropleth = function(df, title="", legend="", buckets=7, zoom=NULL)
{
  c = CountyChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_buckets(buckets)
  c$set_zoom(zoom)
  c$render()
}
