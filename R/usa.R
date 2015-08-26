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
    render = function()
    {
      self$prepare_map()
      
      if (private$zoom == "alaska" || private$zoom == "hawaii") {
        choro = self$render_helper(self$choropleth.df, self$scale_name, self$theme_clean()) + ggtitle(self$title)
        if (self$add_state_outline)
        {
          choro + self$render_state_outline(private$zoom)
        }        
      } else {
        # remove AK and HI from the "real" df
        continental.df = self$choropleth.df[!self$choropleth.df$state %in% c("alaska", "hawaii"), ]
        continental.ggplot = self$render_helper(continental.df, self$scale_name, self$theme_clean()) + ggtitle(self$title)
        if (self$add_state_outline)
        {
          continental.regions = subset(private$zoom, private$zoom!="alaska" & private$zoom!="hawaii")
          continental.ggplot = continental.ggplot + self$render_state_outline(continental.regions)
        }
        
        ret = continental.ggplot
  
        # subset AK and render it
        if (is.null(private$zoom) || 'alaska' %in% private$zoom)
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
        if (is.null(private$zoom) || 'hawaii' %in% private$zoom)
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
      }
    },
    
    render_helper = function(choropleth.df, scale_name, theme)
    {
      # maps with numeric values are mapped with a continuous scale
      if (is.numeric(choropleth.df$value))
      {
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          self$ggplot_polygon  + 
          self$get_scale() + 
          self$projection + 
          theme;
      } else { # assume character or factor
        stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
        
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          self$ggplot_polygon  + 
          self$get_scale() + 
          self$projection +
          theme;
      }
    },
    
    render_state_outline = function(states)
    {
      if (!requireNamespace("choroplethrMaps", quietly = TRUE)) {
        stop("Package choroplethrMaps is needed for this function to work. Please install it.", call. = FALSE)
      }
      
      data(state.map, package="choroplethrMaps", envir=environment())
      data(state.regions, package="choroplethrMaps", envir=environment())
      
      stopifnot(states %in% state.regions$region)
      
      df = state.map[state.map$region %in% states, ]
      geom_polygon(data=df, aes(long, lat, group = group), color = "black", fill = NA, size = 0.2);
    },
    
    # all maps of US states zoom at the unit of states.
    set_zoom = function(zoom)
    {
      if (!requireNamespace("choroplethrMaps", quietly = TRUE)) {
        stop("Package choroplethrMaps is needed for this function to work. Please install it.", call. = FALSE)
      }
      
      data(state.map, package="choroplethrMaps", envir=environment())
      all_states = unique(state.map$region)
      
      if (is.null(zoom))
      {
        # initialize the map to the max zoom - i.e. all regions
        private$zoom = all_states     
      } else {
        stopifnot(all(zoom %in% all_states))
        private$zoom = zoom
      }
    }
  )
)

