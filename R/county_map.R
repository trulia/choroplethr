#' Map of the counties of each of the 50 US states plus the district of columbia.
#' 
#' A data.frame which contains a map of all 50 US States plus 
#' the District of Columbia.  The shapefile
#' was modified using QGIS in order to 1) remove
#' Puerto Rico 2) remove islands off of Alaska that
#' crossed the antimeridian 3) renamed the county "Dona Ana" (which is properly written with a tilde over the
#' first "n") to "Dona Ana" because R CMD check emits a warning if data contains non-ASCII characters 4) some columns were added for convenience.
#'
#' @docType data
#' @name county.map
#' @usage data(county.map)
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
NULL

#' A data.frame consisting of the name of each county in the US as well as the county FIPS code (as both a character and integer),
#' the state name (as both a full name and an abbreviation) as well as the state FIPS code (as both a character and an integer).
#'  
#' @docType data
#' @name county.names
#' @usage data(county.names)
NULL
