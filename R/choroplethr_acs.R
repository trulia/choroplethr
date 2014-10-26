if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("state.fips"))
}

#' Create a choropleth from ACS data.
#' 
#' Creates a choropleth using the US Census' American Community Survey (ACS) data.  
#' Requires the acs package to be installed, and a Census API Key to be set with 
#' the acs's api.key.install function.  Census API keys can be obtained at http://www.census.gov/developers/tos/key_request.html.
#'
#' @param tableId The id of an ACS table
#' @param map A string indicating which map the data is for.  Must be "state", "county" or "zip".
#' @param endyear The end year of the survey to use.  See acs.fetch (?acs.fetch) and http://1.usa.gov/1geFSSj for details.
#' @param span The span of time to use.  See acs.fetch and http://1.usa.gov/1geFSSj for details.
#' on the same longitude and latitude map to scale. This variable is only checked when the "states" variable is equal to all 50 states.
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional list of states to zoom in on. Must come from the "name" column in
#' ?state.regions.
#' @return A choropleth.
#' 
#' @keywords choropleth, acs
#' 
#' @seealso \code{api.key.install} in the acs package which sets an Census API key for the acs library
#' @seealso http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS 
#' which contains a list of all ACS surveys.
#' @references Uses the acs package created by Ezra Haber Glenn.

#' @export
#' @examples
#' \dontrun{
#' # population of all states, 9 equally sized buckets
#' choroplethr_acs("B01003", "state")
#' 
#' # median income, continuous scale, counties in New York, New Jersey and Connecticut
#' choroplethr_acs("B19301", "county", buckets=1, zoom=c("new york", "new jersey", "connecticut"))
#'
#' # median income, all zip codes
#' choroplethr_acs("B19301", "zip") } 
#' @importFrom acs acs.fetch geography estimate geo.make
choroplethr_acs = function(tableId, map, endyear=2011, span=5, buckets=7, zoom=NULL)
{
  stopifnot(map %in% c("state", "county", "zip"))
  stopifnot(buckets > 0 && buckets < 10)
  
  acs.data   = acs.fetch(geography=make_geo(map), table.number = tableId, col.names = "pretty", endyear = endyear, span = span)
  column_idx = get_column_idx(acs.data, tableId) # some tables have multiple columns 
  title      = acs.data@acs.colnames[column_idx] 
  acs.df     = make_df(map, acs.data, column_idx) # choroplethr requires a df
  
  if (map=="state") {
    state_choropleth(acs.df, title, "", buckets, zoom)
  } else if (map=="county") {
    county_choropleth(acs.df, title, "", buckets, zoom)
  } else if (map=="zip") {
    zip_map(acs.df, title, "", buckets, zoom)
  }
}

#' Returns a data.frame representing American Community Survey estimates.
#' 
#' Requires the acs package to be installed, and a Census API Key to be set with the 
#' acs's api.key.install function.  Census API keys can be obtained at http://www.census.gov/developers/tos/key_request.html.
#'
#' @param tableId The id of an ACS table.
#' @param map The map you want the data to match. Must be one of "state", "county" or "zip". 
#' @param endyear The end year of the survey.  Defaults to 2012.
#' @param span The span of the survey.  Defaults to 5.
#' @param column_idx An optional column index to specify.
#' @return A data.frame.
#' @export
#' @seealso http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS, which lists all ACS Surveys.
#' @importFrom acs acs.fetch geography estimate geo.make
#' @examples
#' \dontrun{
#' library(Hmisc) # for cut2
#' # States with greater than 1M residents
#' df       = get_acs_df("B01003", "state") # population
#' df$value = cut2(df$value, cuts=c(0,1000000,Inf))
#' state_choropleth(df, title="States with a population over 1M", legend="Population")
#'
#' # Counties with greater than or greater than 1M residents
#' df       = get_acs_df("B01003", "county") # population
#' df$value = cut2(df$value, cuts=c(0,1000000,Inf))
#' county_choropleth(df, title="Counties with a population over 1M", legend="Population")
#' 
#' # ZIP codes in California where median age is between 20 and 30
#' df       = get_acs_df("B01002", "zip") # median age
#' df       = df[df$value >= 20 & df$value <= 30, ]
#' df$value = cut2(df$value, g=3) # 3 equally-sized groups
#' zip_map(df, title="CA Zip Codes by Age", legend="Median Age", zoom="california")
#' }
get_acs_df = function(tableId, map, endyear=2012, span=5, column_idx = -1)
{
  stopifnot(map %in% c("state", "county", "zip"))
  
  acs.data   = acs.fetch(geography=make_geo(map), table.number = tableId, col.names = "pretty", endyear = endyear, span = span)
  if (column_idx == -1) {
    column_idx = get_column_idx(acs.data, tableId) # some tables have multiple columns 
  }
  make_df(map, acs.data, column_idx) # turn into df
}

# support multiple column tables
get_column_idx = function(acs.data, tableId)
{
  column_idx = 1
  if (length(acs.data@acs.colnames) > 1)
  {
    num_cols   = length(acs.data@acs.colnames)
    title      = paste0("Table ", tableId, " has ", num_cols, " columns.  Please choose which column to render:")
    column_idx = menu(acs.data@acs.colnames, title=title)
  }
  column_idx
}

make_geo = function(map)
{
  stopifnot(map %in% c("state", "county", "zip"))
  if (map == "state") {
    geo.make(state = "*")
  } else if (map == "county") {
    geo.make(state = "*", county = "*")
  } else {
    geo.make(zip.code = "*")
  }
}

make_df = function(map, acs.data, column_idx) 
{
  stopifnot(map %in% c("state", "county", "zip"))
  
  if (map == "state") {
    df = data.frame(region = tolower(geography(acs.data)$NAME), 
                    value  = as.numeric(estimate(acs.data[,column_idx])));
    df[df$region != "puerto rico", ]
  } else if (map == "county") {
    # create fips code
    acs.data@geography$fips = paste(as.character(acs.data@geography$state), 
                                    acs.data@geography$county, 
                                    sep = "")
    # put in format for call to all_county_choropleth
    acs.data@geography$fips = as.numeric(acs.data@geography$fips)
    df = data.frame(region = geography(acs.data)$fips, 
                    value  = as.numeric(estimate(acs.data[,column_idx])));
    # remove state fips code 72, which is Puerto Rico, which we don't map
    df[df$region < 72000 | df$region > 72999, ]     
  } else if (map == "zip") {
    # put in format for call to choroplethr
    acs.df = data.frame(region = geography(acs.data)$zipcodetabulationarea, 
                        value  = as.numeric(estimate(acs.data[,column_idx])))
    
    na.omit(acs.df) # surprisingly, this sometimes returns NA values
  }
}