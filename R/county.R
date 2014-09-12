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
    },
    
    # TODO: What if private$zoom is NULL and user enters "puerto rico"?
    # TODO: need to WARN here!
    # support e.g. users just viewing states on the west coast
    clip = function() {
      if (!is.null(private$zoom))
      {
        # user.df has county FIPS codes for regions, but subsetting happens at the state level
        self$user.df$state = merge(self$user.df, county.names, sort=FALSE, all=TRUE, by.x="region", by.y="county.fips.numeric")$state.name
        self$user.df = self$user.df[self$user.df$state %in% private$zoom, ]
        self$user.df$state = NULL
        
        self$map.df  = self$map.df[self$map.df$state %in% private$zoom, ]
      }
    }
  )
)


#' Create a choropleth of USA Counties with sensible defaults.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  
#' @param title An optional title for the map.  
#' @param legend_name An optional name for the legend.  
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional list of states to zoom in on. Must come from the "name" column in
#' ?state.names.
#' 
#' @examples
#' data(df_pop_county)
#' county_choropleth(df_pop_county, title="US 2012 Population Estimates", legend_name="Population")
#'
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit

county_choropleth = function(df, title="", legend_name="", num_buckets=7, zoom=NULL)
{
  c = CountyChoropleth$new(df)
  c$title       = title
  c$legend_name = legend_name

  if (!is.null(zoom))
  {
    c$set_zoom(zoom)
  }
  c$render(num_buckets)
}
