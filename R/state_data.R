#' Map of the 50 US states plus the district of columbia.
#' 
#' A data.frame which contains a map of all 50 US States plus 
#' the District of Columbia.  The shapefile
#' was modified using QGIS in order to 1) remove
#' Puerto Rico and 2) remove islands off of Alaska that
#' crossed the antimeridian 3) renamed column "STATE" to "region".
#'
#' @docType data
#' @name map.states
#' @usage data(map.states)
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
#' 
#' @examples
#' data(map.states)
#' require(ggplot2)
#' require(grid)
#' 
#' # simple map of all states.  
#' ggplot(map.states, aes(long, lat,group=group)) + geom_polygon()
#' 
#' # render Alaska and Hawaii as insets on a map of the contiguous 48 states.
#'  
#' # render lower 48 as a ggplot 
#' states.48 = map.states[!map.states$region %in% c("alaska", "hawaii"), ]
#' base_map     = ggplot(states.48, aes(long, lat,group=group)) + geom_polygon() + theme_clean()
#'
#' # subset AK and render it
#' alaska.df     = map.states[map.states$region=='alaska',]
#' alaska.ggplot = ggplot(alaska.df, aes(long, lat, group=group)) + geom_polygon() + theme_clean()
#' alaska.grob   = ggplotGrob(alaska.ggplot)
#'
#' # subset HI and render it
#' hawaii.df     = map.states[map.states$region=='hawaii',]
#' hawaii.ggplot = ggplot(hawaii.df, aes(long, lat, group=group)) + geom_polygon() + theme_clean()
#' hawaii.grob   = ggplotGrob(hawaii.ggplot)
#'
#' # now render the final image
#' base_map +
#'  annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
#'  annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30) 
NULL

#' A data.frame consisting of all 50 state names (plus the District of Columbia), postal codes,
#' and FIPS codes both as characters and numbers (i.e. with and without a leading 0).
#' 
#' @docType data
#' @name state.names
#' @usage data(state.names)
#' @references Taken from http://www.epa.gov/envirofw/html/codes/state.html
NULL
