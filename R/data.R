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
#' crossed the antimeridian.
#'
#' @docType data
#' @name all.us.states.map.df
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
#' 
#' @examples
#' data(all.us.states.map.df)
#' require(ggplot2)
#' require(grid)
#' 
#' # simple map of all states.  
#' ggplot(all.us.states.map.df, aes(long, lat,group=group)) + geom_polygon()
#' 
#' # render Alaska and Hawaii as insets on a map of the contiguous 48 states.
#'  
#' # render lower 48 as a ggplot 
#' us.states.48 = all.us.states.map.df[!all.us.states.map.df$NAME %in% c("Alaska", "Hawaii"), ]
#' base_map     = ggplot(us.states.48, aes(long, lat,group=group)) + geom_polygon() + theme_clean()
#'
#' # subset AK and render it
#' alaska.df     = all.us.states.map.df[all.us.states.map.df$NAME=='Alaska',]
#' alaska.ggplot = ggplot(alaska.df, aes(long, lat, group=group)) + geom_polygon() + theme_clean()
#' alaska.grob   = ggplotGrob(alaska.ggplot)
#'
#' # subset HI and render it
#' hawaii.df     = all.us.states.map.df[all.us.states.map.df$NAME=='Hawaii',]
#' hawaii.ggplot = ggplot(hawaii.df, aes(long, lat, group=group)) + geom_polygon() + theme_clean()
#' hawaii.grob   = ggplotGrob(hawaii.ggplot)
#'
#' # now render the final image
#' base_map +
#'  annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
#'  annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30) 
NULL