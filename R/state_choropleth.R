#' @export
#' @importFrom dplyr left_join
StateChoropleth = R6Class("StateChoropleth",
  inherit = Choropleth,
  
  public = list(
    # initialize with us state map
    initialize = function(user.df)
    {
      data(state.map)
      data(state.names)
      super$initialize(state.map, state.names, user.df)
    },
    
    show_labels = TRUE, # should I put e.g. "CA" over California?
    
    render = function(num_buckets = 7)
    {
      self$prepare_map()
      
      # only show the states the user asked
      #choropleth.df = choropleth.df[choropleth.df$region %in% normalize_state_names(states), ]
      
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

      if (is.null(self$regions))
      {
        # subset AK and render it
        alaska.df     = self$choropleth.df[self$choropleth.df$region=='alaska',]
        alaska.ggplot = self$print_state_choropleth(alaska.df, "", self$theme_inset(), min_val, max_val)    
        alaska.grob   = ggplotGrob(alaska.ggplot)
        
        # subset HI and render it
        hawaii.df     = self$choropleth.df[self$choropleth.df$region=='hawaii',]
        hawaii.ggplot = self$print_state_choropleth(hawaii.df, "", self$theme_inset(), min_val, max_val)
        hawaii.grob   = ggplotGrob(hawaii.ggplot)
        
        # remove AK and HI from the "real" df
        self$choropleth.df = self$choropleth.df[!self$choropleth.df$region %in% c("alaska", "hawaii"), ]
      }
      
      choropleth = self$print_state_choropleth(self$choropleth.df, self$scale_name, self$theme_clean(), min_val, max_val) + ggtitle(self$title)
      
      if (is.null(self$regions))
      {
        choropleth = choropleth + 
          annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
          annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)    
      }
      
      # let's assume that people who want labels don't need them for AK and HI
      if (self$show_labels) {
        df_state_labels = data.frame(long = state.center$x, lat = state.center$y, label = state.abb)
        df_state_labels = df_state_labels[!df_state_labels$label %in% c("AK", "HI"), ]
        df_state_labels = df_state_labels[df_state_labels$label %in% states, ]
        choropleth = choropleth + geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
      }
      
      choropleth    
    },
              
    print_state_choropleth = function(choropleth.df, scale_name, theme, min, max)
    {
      # maps with numeric values are mapped with a continuous scale
      if (is.numeric(choropleth.df$value))
      {
        ggplot(choropleth.df, aes(long, lat, group = group)) +
          geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
          get_scale(min, max)
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