#' Normal choropleth that draws Alaska and Hawaii as insets. 
#' In addition to a columns named "region" and "value", also requires a column named "state".
#' @export
#' @importFrom dplyr left_join
#' @include choropleth.R
USAChoropleth = R6Class("USAChoropleth",
  inherit = Choropleth,
  
  public = list(
    add_state_outline = FALSE,
    
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
            
      # remove AK and HI from the "real" df
      continental.df = self$choropleth.df[!self$choropleth.df$state %in% c("alaska", "hawaii"), ]
      continental.ggplot = self$render_helper(continental.df, self$scale_name, self$theme_clean()) + ggtitle(self$title)
      if (self$add_state_outline)
      {
        continental.names = subset(self$regions, self$regions!="alaska" & self$regions!="hawaii")
        continental.ggplot = continental.ggplot + self$render_state_outline(continental.names)
      }
      
      ret = continental.ggplot

      # subset AK and render it
      if (is.null(self$regions) || 'alaska' %in% self$regions)
      {
        alaska.df     = self$choropleth.df[self$choropleth.df$state=='alaska',]
        alaska.ggplot = self$render_helper(alaska.df, "", self$theme_inset())
        if (self$add_state_outline)
        {
          alaska.ggplot = alaska.ggplot + self$render_state_outline('alaska')
        }
        alaska.grob = ggplotGrob(alaska.ggplot)
        ret = ret + annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)
      }
      
      # subset HI and render it
      if (is.null(self$regions) || 'hawaii' %in% self$regions)
      {
        hawaii.df     = self$choropleth.df[self$choropleth.df$state=='hawaii',]
        hawaii.ggplot = self$render_helper(hawaii.df, "", self$theme_inset())
        if (self$add_state_outline)
        {
          hawaii.ggplot = hawaii.ggplot + self$render_state_outline('hawaii')
        }
        hawaii.grob = ggplotGrob(hawaii.ggplot)
        ret = ret + annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5)
      }
      
      ret +
        ggtitle(self$title)
    },
    
    render_helper = function(choropleth.df, scale_name, theme)
    {
      # maps with numeric values are mapped with a continuous scale
      if (is.numeric(choropleth.df$value))
      {
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
          self$get_scale() + 
          theme;
      } else { # assume character or factor
        stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
        
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
          self$get_scale() + 
          theme;
      }
    },
    
    render_state_outline = function(states)
    {
      data(state.map  , package="choroplethr", envir=environment())
      data(state.names, package="choroplethr", envir=environment())
      
      stopifnot(states %in% state.names$name)
      
      df = state.map[state.map$region %in% states, ]
      geom_polygon(data=df, aes(long, lat, group = group), color = "black", fill = NA, size = 0.2);
    }
  )
)

