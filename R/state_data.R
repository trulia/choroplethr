#' Map of the 50 US states plus the district of columbia.
#' 
#' A data.frame which contains a map of all 50 US States plus 
#' the District of Columbia.  The shapefile
#' was modified using QGIS in order to 1) remove
#' Puerto Rico and 2) remove islands off of Alaska that
#' crossed the antimeridian 3) renamed column "STATE" to "region".
#'
#' @docType data
#' @name state.map
#' @usage data(state.map)
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
NULL

#' A data.frame consisting of all 50 state names (plus the District of Columbia), postal codes,
#' and FIPS codes both as characters and numbers (i.e. with and without a leading 0).
#' 
#' @docType data
#' @name state.names
#' @usage data(state.names)
#' @references Taken from http://www.epa.gov/envirofw/html/codes/state.html
NULL

#' A data.frame containing election results from the 2012 US Presidential election.  
#'
#' @name df_president
#' @docType data
#' @references Taken from \url{http://www.fec.gov/pubrec/fe2012/federalelections2012.shtml} on 3/15/2014. 
#' @keywords data
#' @usage data(choroplethr)
NULL

#' A data.frame containing population estimates for US States in 2012.   
#'
#' @name df_pop_state
#' @docType data
#' @references Taken from the US American Community Survey (ACS) 5 year estimates.
#' 
#' @keywords data
#' @usage data(choroplethr)
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
#' @usage data(choroplethr)
NULL