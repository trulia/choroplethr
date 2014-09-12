#' Create a state-level choropleth
#' @export
#' @importFrom dplyr left_join
#' @include usa.R
StateChoropleth = R6Class("StateChoropleth",
  inherit = USAChoropleth,
  
  public = list(
    show_labels = TRUE,
    
    # initialize with us state map
    initialize = function(user.df)
    {
      data(state.map)
      state.map$state = state.map$region
      super$initialize(state.map, user.df)
    },
    
    render = function()
    {
      choropleth = super$render()
      
      # by default, add labels for the lower 48 states
      if (self$show_labels) {
        df_state_labels = data.frame(long = state.center$x, lat = state.center$y, name=tolower(state.name), label = state.abb)
        df_state_labels = df_state_labels[!df_state_labels$name %in% c("alaska", "hawaii"), ]
        if (!is.null(self$zoom))
        {
          df_state_labels = df_state_labels[df_state_labels$name %in% self$zoom, ]
        }
        choropleth = choropleth + geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
      }
      
      choropleth
    }
  )
)


#' Create a choropleth of USA States with sensible defaults.
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
#' data(df_pop_state)
#' state_choropleth(df_pop_state, title="US 2012 Population Estimates", legend_name="Population")
#'
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit
state_choropleth = function(df, title="", legend_name="", num_buckets=7, zoom=NULL)
{
  c = StateChoropleth$new(df)
  c$title       = title
  c$legend_name = legend_name
  c$set_num_buckets(num_buckets)
  if (!is.null(zoom))
  {
    c$set_zoom(zoom)
  }
  c$render()
}
