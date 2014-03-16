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