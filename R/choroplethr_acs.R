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
#' @param lod A string indicating the level of detail of the map.  Must be "state", "county" or "zip".
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets.  For
#' example, 2 will show values above or below the median, and 9 will show the maximum
#' resolution.  Defaults to 9.
#' @param showLabels For state choropleths, whether or not to show state abbreviations on the map.
#' Defaults to T. 
#' @param states A vector of states to render.  Defaults to state.abb.
#' @param endyear The end year of the survey to use.  See acs.fetch (?acs.fetch) and http://1.usa.gov/1geFSSj for details.
#' @param span The span of time to use.  See acs.fetch and http://1.usa.gov/1geFSSj for details.
#' @return A choropleth.
#' 
#' @keywords choropleth, acs
#' 
#' @seealso \code{\link{choroplethr}} which this function wraps
#' @seealso \code{api.key.install} in the acs package which sets an Census API key for the acs library
#' @seealso http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS 
#' which contains a list of all ACS surveys.
#' @export
#' @examples
#' \dontrun{
#' # population of all states, 9 equally sized buckets
#' choroplethr_acs("B01003", "state")
#' 
#' # median income, continuous scale, counties in New York, New Jersey and Connecticut
#' choroplethr_acs("B19301", "county", num_buckets=1, states=c("NY", "NJ", "CT"))
#'
#' # median income, all zip codes
#' choroplethr_acs("B19301", "zip") } 
#' @importFrom acs acs.fetch geography estimate geo.make
choroplethr_acs = function(tableId, lod, num_buckets = 9, showLabels = T, states = state.abb, endyear = 2011, span = 5)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(num_buckets > 0 && num_buckets < 10)
  
  acs.data   = acs.fetch(geography=make_geo(lod), table.number = tableId, col.names = "pretty", endyear = endyear, span = span)
  column_idx = get_column_idx(acs.data, tableId) # some tables have multiple columns 
  title      = acs.data@acs.colnames[column_idx] 
  acs.df     = make_df(lod, acs.data, column_idx) # choroplethr requires a df
  acs.df$region = as.character(acs.df$region) # not a factor
  choroplethr(acs.df, lod, num_buckets, title, "", showLabels, states=states);  
}

#' Returns a data.frame representing American Community Survey estimates.
#' 
#' Requires the acs package to be installed, and a Census API Key to be set with the 
#' acs's api.key.install function.  Census API keys can be obtained at http://www.census.gov/developers/tos/key_request.html.
#'
#' @param tableId The id of an ACS table.
#' @param lod The level of geographic detail for the data.frame.  Must be one of "state", "county" or "zip". 
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
#' df     = get_acs_df("B01003", "state") # population
#' df.map = bind_df_to_map(df, "state")
#' df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
#' render_choropleth(df.map, "state", "States with a population over 1M", "Population")
#'
#' # Counties with greater than or greater than 1M residents
#' df     = get_acs_df("B01003", "county") # population
#' df.map = bind_df_to_map(df, "county")
#' df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
#' render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")
#' 
#' # ZIP codes in California where median age is between 20 and 30
#' df       = get_acs_df("B01002", "zip") # median age
#' df       = df[df$value >= 20 & df$value <= 30, ]
#' df$value = cut2(df$value, g=3) # 3 equally-sized groups
#' df.map   = bind_df_to_map(df, "zip")
#' render_choropleth(df.map, 
#'                  "zip", 
#'                  title = "CA Zip Codes by Age",
#'                  scaleName = "Median Age",
#'                  states = "CA") 
#' }
get_acs_df = function(tableId, lod, endyear=2012, span=5, column_idx = -1)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  
  acs.data   = acs.fetch(geography=make_geo(lod), table.number = tableId, col.names = "pretty", endyear = endyear, span = span)
  if (column_idx == -1) {
    column_idx = get_column_idx(acs.data, tableId) # some tables have multiple columns 
  }
  acs.df     = make_df(lod, acs.data, column_idx) # turn into df
  acs.df$region = as.character(acs.df$region)
  
  acs.df
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

#' Returns the column names of an ACS table.
#' 
#' @param tableId The id of an ACS table.
#' @param lod The level of geographic detail for the data.frame.  Must be one of "state", "county" or "zip". 
#' @param endyear The end year of the survey.  Defaults to 2012.
#' @param span The span of the survey.  Defaults to 5.
#' @return A vector of column names 
#' @export
#' @seealso http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS, which lists all ACS Surveys.
#' @importFrom acs acs.fetch geography estimate geo.make
get_acs_column_names = function(tableId, lod, endyear=2012, span=5)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(span %in% c(1, 3, 5))
  
  acs.data = acs.fetch(geography=make_geo(lod), table.number = tableId, col.names = "pretty", endyear = endyear, span = span)
  acs.data@acs.colnames
}

make_geo = function(lod)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  if (lod == "state") {
    geo.make(state = "*")
  } else if (lod == "county") {
    geo.make(state = "*", county = "*")
  } else {
    geo.make(zip.code = "*")
  }
}

make_df = function(lod, acs.data, column_idx) 
{
  stopifnot(lod %in% c("state", "county", "zip"))
  
  if (lod == "state") {
    data.frame(region = geography(acs.data)$NAME, 
               value  = as.numeric(estimate(acs.data[,column_idx])));
  } else if (lod == "county") {
    # create fips code
    acs.data@geography$fips = paste(as.character(acs.data@geography$state), 
                                    acs.data@geography$county, 
                                    sep = "");
    # put in format for call to all_county_choropleth
    data.frame(region = geography(acs.data)$fips, 
               value  = as.numeric(estimate(acs.data[,column_idx])));
    
  } else if (lod == "zip") {
    # put in format for call to choroplethr
    acs.df = data.frame(region = geography(acs.data)$zipcodetabulationarea, 
                        value  = as.numeric(estimate(acs.data[,column_idx])))
    
    na.omit(acs.df) # surprisingly, this sometimes returns NA values
  }
}
