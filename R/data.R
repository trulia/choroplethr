#' A data.frame containing election results from the 2012 US Presidential election.  
#'
#' @name df_president
#' @docType data
#' @references Taken from \url{http://www.fec.gov/pubrec/fe2012/federalelections2012.shtml} on 3/15/2014. 
#' @keywords data
#' @examples
#' data(choroplethr)
#' choroplethr(df_president, "state", title="Results from the 2012 US Presidential Election")
NULL

#' A data.frame containing population estimates for US States in 2012.   
#'
#' @name df_pop_state
#' @docType data
#' @references Taken from the US American Community Survey (ACS) 5 year estimates with \link{get_acs_df} using table B01003.
#' 
#' @keywords data
#' @examples
#' data(choroplethr)
#' choroplethr(df_pop_state, "state", title="2012 Population Estimates")
NULL

#' A data.frame containing population estimates for US Counties in 2012.   
#'
#' @name df_pop_county
#' @docType data
#' @references Taken from the US American Community Survey (ACS) 5 year estimates with \link{get_acs_df} using table B01003.
#' 
#' @keywords data
#' @examples
#' data(choroplethr)
#' choroplethr(df_pop_state, "state", title="2012 Population Estimates")
NULL

#' A data.frame containing population estimates for US Zip Code Tabulated Areas (ZCTAs) in 2012.   
#' 
#' ZCTAs are intended to be roughly analogous to postal ZIP codes.
#'
#' @name df_pop_zip
#' @docType data
#' @references Taken from the US American Community Survey (ACS) 5 year estimates with \link{get_acs_df} using table B01003.
#' ZCTAs, and their realationship to ZIP codes, are explained here \url{https://www.census.gov/geo/reference/zctas.html}.
#' @keywords data
#' @examples
#' data(choroplethr)
#' choroplethr(df_pop_state, "state", title="2012 Population Estimates")
NULL

#' A data.frame containing all US presdiential election results from 1789 to 2012
#' 
#' Legend: 
#' \itemize{
#'  \item R = Republican
#'  \item D = Democratic
#'  \item DR = Democratic-Republican
#'  \item W = Whig
#'  \item F = Federalist
#'  \item GW = George Washington
#'  \item NR = National Republican
#'  \item SD = Southern Democrat
#'  \item PR = Progressive
#'  \item AI = American Independent
#'  \item SR = States' Rights
#'  \item PO = Populist
#'  \item CU = Constitutional Union
#'  \item I = Independent
#'  \item ND = Northern Democrat
#'  \item KN = Know Nothing
#'  \item AM = Anti-Masonic
#'  \item N = Nullifier
#'  \item SP = Split evenly
#' }
#' @docType data
#' @references Taken from \url{http://en.wikipedia.org/wiki/List_of_United_States_presidential_election_results_by_state} 3/20/2014.
#' @keywords data
#' @name df_president_ts
NULL

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
#' states.48 = map.states[!map.states$NAME %in% c("alaska", "hawaii"), ]
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
#' @name map.counties
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
NULL

#' A data.frame consisting of all 50 state names (plus the District of Columbia), postal codes,
#' and FIPS codes both as characters and numbers (i.e. with and without a leading 0).
#' 
#' @docType data
#' @name state.names
#' @references Taken from http://www.epa.gov/envirofw/html/codes/state.html
NULL

#' A data.frame consisting of the name of each county in the US as well as the county FIPS code (as both a character and integer),
#' the state name (as both a full name and an abbreviation) as well as the state FIPS code (as both a character and an integer).
#'  
#' @docType data
#' @name county.names
NULL

#' Map of the world.
#' 
#' This data.frame corresponds to version 2.0.0 of the "Admin 0 - Countries" map from naturalearthdata.com
#' The data.frame was modified by removing columns with non-ASCII characters. Also, 
#' I added a column called "region" which is the the all lowercase version of the
#' column "sovereignt". 
#'  
#' @references Taken from http://www.naturalearthdata.com/downloads/110m-cultural-vectors/
#' @docType data
#' @name map.world
NULL

#' Names of all counties on the map.world data.frame
#' @name country.names
#' @docType data
NULL