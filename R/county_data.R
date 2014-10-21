#' A data.frame containing population estimates for US Counties in 2012.   
#'
#' @name df_pop_county
#' @docType data
#' @references Taken from the US American Community Survey (ACS) 5 year estimates.
#' 
#' @keywords data
#' @usage data(df_pop_county)
NULL

#' Map of the counties of each of the 50 US states plus the district of columbia.
#' 
#' A data.frame which contains a map of all 50 US States plus 
#' the District of Columbia.  The shapefile
#' was modified using QGIS in order to 1) remove
#' Puerto Rico 2) remove islands off of Alaska that
#' crossed the antimeridian 3) renamed the county "Dona Ana" (which is properly written with a tilde over the
#' first "n") to "Dona Ana" because R CMD check emits a warning if data contains non-ASCII characters 4) some columns were added for convenience.
#'
#' Note that because of (2) above, county FIPS code 2016 (Aleutians West Census Area, Alaska) is not a part of this map.
#'
#' @docType data
#' @name county.map
#' @usage data(county.map)
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
NULL

#' A data.frame consisting of the name of each county in the map county.map as well as their FIPS codes and state names.
#' 
#' choroplethr requires you to use the naming convention in the "region" column (i.e. the numeric version of 
#' the FIPS code - no leading zero).
#' 
#' @seealso ?county.map
#'  
#' @docType data
#' @name county.names
#' @usage data(county.names)
NULL