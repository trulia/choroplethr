#' Normal choropleth that draws Alaska and Hawaii as insets. 
#' In addition to a columns named "region" and "value", also requires a column named "state".
#' @export
#' @importFrom dplyr left_join
#' @include choropleth.R
USAChoropleth = R6Class("USAChoropleth",
  inherit = Choropleth,
  
  public = list(
    initialize = function(map.df, user.df)
    {
      super$initialize(map.df, user.df)
      # need a state field for doing insets of AK and HI
      stopifnot("state" %in% colnames(map.df)) 
    },
    
    # render the map, with AK and HI as insets
    render = function(num_buckets=7)
    {
      stopifnot(num_buckets > 0 && num_buckets < 10)
      self$num_buckets = num_buckets
      
      self$prepare_map()
      
      # if user requested to render all 50 states, 
      # create separate data.frames for AK and HI and render them as separate images
      # cache min, max value of entire data.frame to make scales consistent between all 3 images
      min_val = 0
      max_val = 0
      if (is.numeric(self$choropleth.df$value))
      {
        min_val = min(self$choropleth.df$value)
        max_val = max(self$choropleth.df$value)
      }
      
      # subset AK and render it
      alaska.df     = self$choropleth.df[self$choropleth.df$state=='alaska',]
      alaska.ggplot = render_helper(alaska.df, "", self$theme_inset(), min_val, max_val)
      alaska.grob   = ggplotGrob(alaska.ggplot)
      
      # subset HI and render it
      hawaii.df     = self$choropleth.df[self$choropleth.df$state=='hawaii',]
      hawaii.ggplot = render_helper(hawaii.df, "", self$theme_inset(), min_val, max_val)
      hawaii.grob   = ggplotGrob(hawaii.ggplot)
      
      # remove AK and HI from the "real" df
      continental.df = self$choropleth.df[!self$choropleth.df$state %in% c("alaska", "hawaii"), ]
      continental.ggplot = render_helper(continental.df, self$scale_name, self$theme_clean(), min_val, max_val) + ggtitle(self$title)
      
      continental.ggplot + 
        annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
        annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30) +   
        ggtitle(self$title)
    },
    
    render_helper = function(choropleth.df, scale_name, theme, min, max)
    {
      # maps with numeric values are mapped with a continuous scale
      if (is.numeric(choropleth.df$value))
      {
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
          get_scale() + 
          theme;
      } else { # assume character or factor
        stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
        
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
          get_scale() + 
          theme;
      }
    }
  )
)

