#' Create a US State choropleth from ACS data
#' 
#' Creates a choropleth of US States using the US Census' American Community Survey (ACS) data.  
#' Requires the acs package to be installed, and a Census API Key to be set with 
#' the acs's api.key.install function.  Census API keys can be obtained at http://www.census.gov/developers/tos/key_request.html.
#'
#' @param tableId The id of an ACS table
#' @param endyear The end year of the survey to use.  See acs.fetch (?acs.fetch) and http://1.usa.gov/1geFSSj for details.
#' @param span The span of time to use.  See acs.fetch and http://1.usa.gov/1geFSSj for details.
#' @param num_colors The number of colors on the map. A value of 1 
#' will use a continuous scale. A value in [2, 9] will use that many colors. 
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
#' # population of all states
#' state_choropleth_acs("B01003")
#' 
#' # median income, continuous scale, counties in New York, New Jersey and Connecticut
#' state_choropleth_acs("B19301", num_colors=1, zoom=c("new york", "new jersey", "connecticut"))
#' }
#' @importFrom acs acs.fetch geography estimate geo.make
state_choropleth_acs = function(tableId, endyear=2011, span=5, num_colors=7, zoom=NULL)
{
  acs.data = get_acs_data("state", tableId, endyear, span)
  state_choropleth(acs.data[['df']], acs.data[['title']], "", num_colors, zoom)
}

#' Create a US County choropleth from ACS data
#' 
#' Creates a US County choropleth using the US Census' American Community Survey (ACS) data.  
#' Requires the acs package to be installed, and a Census API Key to be set with 
#' the acs's api.key.install function.  Census API keys can be obtained at http://www.census.gov/developers/tos/key_request.html.
#'
#' @param tableId The id of an ACS table
#' @param endyear The end year of the survey to use.  See acs.fetch (?acs.fetch) and http://1.usa.gov/1geFSSj for details.
#' @param span The span of time to use.  See acs.fetch and http://1.usa.gov/1geFSSj for details.
#' @param num_colors The number of colors on the map. A value of 1 
#' will use a continuous scale. A value in [2, 9] will use that many colors. 
#' @param state_zoom An optional vector of states to zoom in on. Elements of this vector must exactly 
#' match the names of states as they appear in the "region" column of ?state.regions.
#' @param county_zoom An optional vector of counties to zoom in on. Elements of this vector must exactly 
#' match the names of counties as they appear in the "region" column of ?county.regions.
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
#' # population of all counties
#' county_choropleth_acs("B01003")
#' 
#' # median income, continuous scale, counties in New York, New Jersey and Connecticut
#' county_choropleth_acs("B19301", num_colors=1, state_zoom=c("new york", "new jersey", "connecticut"))
#' 
#' library(dplyr)
#' library(choroplethrMaps)
#' data(county.regions)
#'
#' # median income of the 5 counties (boroughs) that make up New York City
#' nyc_county_names=c("kings", "bronx", "new york", "queens", "richmond")
#' nyc_county_fips = county.regions %>%
#'   filter(state.name=="new york" & county.name %in% nyc_county_names) %>%
#'   select(region)
#' county_choropleth_acs("B19301", num_colors=1, county_zoom=nyc_county_fips$region)
#' }
#' @importFrom acs acs.fetch geography estimate geo.make
county_choropleth_acs = function(tableId, endyear=2011, span=5, num_colors=7, state_zoom=NULL, county_zoom=NULL)
{
  acs.data = get_acs_data("county", tableId, endyear, span)
  county_choropleth(acs.data[['df']], acs.data[['title']], "", num_colors, state_zoom, county_zoom)
}

#' Create a US ZIP choropleth from ACS data
#' 
#' Creates a US ZIP choropleth using the US Census' American Community Survey (ACS) data.  
#' Requires the acs package to be installed, and a Census API Key to be set with 
#' the acs's api.key.install function.  Census API keys can be obtained at http://www.census.gov/developers/tos/key_request.html.
#'
#' @param tableId The id of an ACS table
#' @param map A string indicating which map the data is for.  Must be "state", "county" or "zip".
#' @param endyear The end year of the survey to use.  See acs.fetch (?acs.fetch) and http://1.usa.gov/1geFSSj for details.
#' @param span The span of time to use.  See acs.fetch and http://1.usa.gov/1geFSSj for details.
#' on the same longitude and latitude map to scale. This variable is only checked when the "states" variable is equal to all 50 states.
#' @param num_colors The number of colors on the map. A value of 1 
#' will use a continuous scale. A value in [2, 9] will use that many colors. 
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
#' # population of all ZIPs in NY State
#' zip_choropleth_acs("B01003", state_zoom="new york")
#' 
#' } 
#' @importFrom acs acs.fetch geography estimate geo.make
zip_choropleth_acs = function(tableId, endyear=2011, span=5, num_colors=7, zip_zoom=NULL, county_zoom=NULL, state_zoom=NULL, msa_zoom=NULL)
{
  acs.data = get_acs_data("zip", tableId, endyear, span)
  zip_choropleth(acs.data[['df']], acs.data[['title']], "", num_colors,  zip_zoom, county_zoom, state_zoom, msa_zoom)
}

# given an American Community Survey (ACS) tableId, endyear and span
# prompts user for the column id if there are multiple tables
# returns the result as a data.frame with one column named region and one column named value
# note: the regions are clipped to the maps that choroplethr uses. i.e., 
get_acs_data = function(map, tableId, endyear, span)
{
  acs.data   = acs.fetch(geography=make_geo(map), table.number = tableId, col.names = "pretty", endyear = endyear, span = span)
  column_idx = get_column_idx(acs.data, tableId) # some tables have multiple columns 
  title      = acs.data@acs.colnames[column_idx] 
  df         = make_df(map, acs.data, column_idx) # choroplethr requires a df
  list(df=df, title=title) # need to return 2 values here
}

#' Returns a data.frame representing American Community Survey estimates
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

# convert the acs.data to a data.frame in the format that choroplethr uses.
# this is trickty for a few reasons. one of which is that acs.data is an S4 object.
# another is that each map (state, county and zip) has a different naming convention for regions
# another is that the census data needs to be clipped to the map (e.g. remove puerto rico)
make_df = function(map, acs.data, column_idx) 
{
  stopifnot(map %in% c("state", "county", "zip"))
  
  if (map == "state") {
    df = data.frame(region = tolower(geography(acs.data)$NAME), 
                    value  = as.numeric(estimate(acs.data[,column_idx])));
    df$region = as.character(df$region)
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
    acs.df$region = as.character(acs.df$region)
    
    # I removed zips in e.g. puerto rico from the map, so remove them here too to avoid a
    # "your data contains unmappable region" error later on
    if (!requireNamespace("choroplethrZip", quietly = TRUE)) {
      stop("Package choroplethrZip is needed for this function to work. Please install it.", call. = FALSE)
    }
    
    data(zip.regions, package="choroplethrZip", envir=environment())
    acs.df[acs.df$region %in% unique(zip.regions$region), ]
  }
}