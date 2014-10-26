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
      data(state.map, package="choroplethrMaps")
      state.map$state = state.map$region
      super$initialize(state.map, user.df)
      
      if (private$has_invalid_regions)
      {
        warning("Please see ?state.regions for a list of mappable regions")
      }
    },
    
    render = function()
    {
      choropleth = super$render()
      
      # by default, add labels for the lower 48 states
      if (self$show_labels) {
        df_state_labels = data.frame(long = state.center$x, lat = state.center$y, name=tolower(state.name), label = state.abb)
        df_state_labels = df_state_labels[!df_state_labels$name %in% c("alaska", "hawaii"), ]
        df_state_labels = df_state_labels[df_state_labels$name %in% private$zoom, ]

        choropleth = choropleth + geom_text(data = df_state_labels, aes(long, lat, label = label, group = NULL), color = 'black')
      }
      
      choropleth
    }
  )
)


#' Create a choropleth of US States with sensible defaults.
#' 
#' The map used is state.map in the package choroplethrMaps.  See state.regions in 
#' the choroplethrMaps package for a data.frame that can help you coerce your regions 
#' into the required format.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Elements in 
#' the "region" column must exactly match how regions are named in the "region" column in state.map.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional vector of states to zoom in on. Elements of this vector must exactly 
#' match the names of states as they appear in the "region" column of ?state.regions.
#' 
#' @examples
#' # demonstrate default parameters - visualization using 7 equally sized buckets
#' data(df_pop_state)
#' state_choropleth(df_pop_state, title="US 2012 State Population Estimates", legend="Population")
#'
#' # demonstrate continuous scale and zoom
#' data(df_pop_state)
#' state_choropleth(df_pop_state, 
#'                  title="US 2012 State Population Estimates", 
#'                  legend="Population", 
#'                  buckets=1,
#'                  zoom=c("california", "oregon", "washington"))
#' 
#' # demonstrate how choroplethr handles character and factor values
#' # demonstrate user creating their own discretization of the input
#' data(df_pop_state)
#' df_pop_state$str = ""
#' for (i in 1:nrow(df_pop_state))
#' {
#'   if (df_pop_state[i,"value"] < 1000000)
#'   {
#'     df_pop_state[i,"str"] = "< 1M"
#'   } else {
#'     df_pop_state[i,"str"] = "> 1M"
#'   }
#' }
#' df_pop_state$value = df_pop_state$str
#' state_choropleth(df_pop_state, title="Which states have less than 1M people?")
#' 
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_colour_brewer
#' @importFrom scales comma
#' @importFrom grid unit
state_choropleth = function(df, title="", legend="", buckets=7, zoom=NULL)
{
  c = StateChoropleth$new(df)
  c$title  = title
  c$legend = legend
  c$set_buckets(buckets)
  c$set_zoom(zoom)
  c$render()
}
