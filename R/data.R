#' A data.frame containing election results from the 2012 US Presidential election.  
#'
#' @name df_president
#' @docType data
#' @references Taken from \url{http://www.fec.gov/pubrec/fe2012/federalelections2012.shtml} on 3/15/2014. 
#' @keywords data
#' @usage data(choroplethr)
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
#' @usage data(choroplethr)
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
#' @usage data(choroplethr)
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
#' @usage data(choroplethr)
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
#' @usage data(choroplethr)
NULL

#' A world map
#' 
#' This data.frame corresponds to version 2.0.0 of the "Admin 0 - Countries" map from naturalearthdata.com
#' The data.frame was modified by removing columns with non-ASCII characters. Also, 
#' I added a column called "region" which is the the all lowercase version of the
#' column "sovereignt". 
#' 
#' Note that due to the resolution of the map (1:110m, or 1 cm=1,100 km), small countries are not
#' represented on this map.  See ?country.names for a list of all countries represented on the map.
#'  
#' @references Taken from http://www.naturalearthdata.com/downloads/110m-cultural-vectors/
#' @docType data
#' @name map.world
#' @usage data(map.world)
NULL

#' Names of all counties on the map.world data.frame. A data.frame that includes both English names and
#' their iso2c equivalents.
#' @name country.names
#' @usage data(country.names)
#' @docType data
NULL