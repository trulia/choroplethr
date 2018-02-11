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
      if (!requireNamespace("choroplethrMaps", quietly = TRUE)) {
        stop("Package choroplethrMaps is needed for this function to work. Please install it.", call. = FALSE)
      }

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
