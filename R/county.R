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
      if (!requireNamespace("choroplethrMaps", quietly = TRUE)) {
        stop("Package choroplethrMaps is needed for this function to work. Please install it.", call. = FALSE)
      }

      data(county.map, package="choroplethrMaps", envir=environment())
      data(county.regions, package="choroplethrMaps", envir=environment())
      # USAChoropleth requires a column called "state" that has full lower case state name (e.g. "new york")
      county.map$state = merge(county.map, county.regions, sort=FALSE, by.x="region", by.y="region")$state.name
      super$initialize(county.map, user.df)
      
      # by default, show all states on the map
      data(state.map, package="choroplethrMaps", envir=environment())
      private$zoom = unique(state.map$region)
      
      if (private$has_invalid_regions)
      {
        warning("Please see ?county.regions for a list of mappable regions")
      }
      
    },
    
    # user.df has county FIPS codes for regions, but subsetting happens at the state level
    clip = function() 
    {
      # remove regions not on the map before doing the merge
      data(county.regions, package="choroplethrMaps", envir=environment())

      self$user.df = self$user.df[self$user.df$region %in% county.regions$region, ]
      self$user.df$state = merge(self$user.df, county.regions, sort=FALSE, all.X=TRUE, by.x="region", by.y="region")$state.name
      self$user.df = self$user.df[self$user.df$state %in% private$zoom, ]
      self$user.df$state = NULL
        
      self$map.df  = self$map.df[self$map.df$state %in% private$zoom, ]
    }
  )
)


#' Create a choropleth of US Counties
#' 
#' The map used is county.map in the choroplethrMaps package.  See country.regions
#' in the choroplethrMaps package for an object which can help you coerce your regions
#' into the required format.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in county.map.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param num_colors The number of colors on the map. A value of 1 
#' will use a continuous scale. A value in [2, 9] will use that many colors. 
#' @param state_zoom An optional vector of states to zoom in on. Elements of this vector must exactly 
#' match the names of states as they appear in the "region" column of ?state.regions.
#' @param county_zoom An optional vector of counties to zoom in on. Elements of this vector must exactly 
#' match the names of counties as they appear in the "region" column of ?county.regions.
#' @param reference_map If true, render the choropleth over a reference map from Google Maps.
#' 
#' @examples
#' \dontrun{
#' # default parameters
#' data(df_pop_county)
#' county_choropleth(df_pop_county, 
#'                   title  = "US 2012 County Population Estimates", 
#'                   legend = "Population")
#'                   
#' # zoom in on california and add a reference map
#' county_choropleth(df_pop_county, 
#'                   title         = "California County Population Estimates", 
#'                   legend        = "Population",
#'                   state_zoom    = "california",
#'                   reference_map = TRUE)
#'
#' # continuous scale 
#' data(df_pop_county)
#' county_choropleth(df_pop_county, 
#'                  title      = "US 2012 County Population Estimates", 
#'                  legend     = "Population", 
#'                  num_colors = 1, 
#'                  state_zoom = c("california", "oregon", "washington"))
#'
#' library(dplyr)
#' library(choroplethrMaps)
#' data(county.regions)
#'
#' # show the population of the 5 counties (boroughs) that make up New York City
#' nyc_county_names = c("kings", "bronx", "new york", "queens", "richmond")
#' nyc_county_fips = county.regions %>%
#'   filter(state.name == "new york" & county.name %in% nyc_county_names) %>%
#'   select(region)
#' county_choropleth(df_pop_county, 
#'                   title        = "Population of Counties in New York City",
#'                   legend       = "Population",
#'                   num_colors   = 1,
#'                   county_zoom = nyc_county_fips$region)
#' }
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit
county_choropleth = function(df, title="", legend="", num_colors=7, state_zoom=NULL, county_zoom=NULL, reference_map=FALSE)
{
  # user can only zoom in by one of the zoom options
  if (!is.null(state_zoom) && !is.null(county_zoom))
  {
    stop("You cannnot set state_zoom and county_zoom at the same time.")
  }

  if (!is.null(county_zoom))
  {
    c = CountyZoomChoropleth$new(df)
    c$title  = title
    c$legend = legend
    c$set_num_colors(num_colors)
    c$set_zoom(county_zoom)
    if (reference_map) {
      c$render_with_reference_map()
    } else {
      c$render()
    }
  } else {
    c = CountyChoropleth$new(df)
    c$title  = title
    c$legend = legend
    c$set_num_colors(num_colors)
    c$set_zoom(state_zoom)
    if (reference_map) {
      if (is.null(state_zoom))
      {
        stop("Reference maps do not currently work with maps that have insets, such as maps of the 50 US States.")
      }
      c$render_with_reference_map()
    } else {
      c$render()
    }
  }
}
