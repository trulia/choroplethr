# code to transparently generate choropleths from the American Community Survey (ACS)
# using the acs package (http://cran.r-project.org/web/packages/acs/).
# The census stores data in tables.  A list of tableIds of the 2011 ACS can be found here:
# http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_11_5YR#

acs_all_county_choropleth = function(tableId, num_buckets = 9)
{
  # get census data for all counties from specified table
  us.county = geo.make(state = "*", county = "*");
  acs.data  = acs.fetch(geography=us.county, table.number = tableId, col.names = "pretty");
  # create fips code
  acs.data@geography$fips = paste(as.character(acs.data@geography$state), 
                                  acs.data@geography$county, 
                                  sep = "");
  # put in format for call to all_county_choropleth
  acs.df = data.frame(fips  = geography(acs.data)$fips, 
                      value = as.numeric(estimate(acs.data)));
  title  = acs.data@acs.colnames; 
  county_choropleth(acs.df, num_buckets, title);  
}

acs_all_state_choropleth = function(tableId, num_buckets = 9, showLabels = T)
{
  # get census data for all states from specified table
  us.state = geo.make(state = "*");
  acs.data = acs.fetch(geography=us.state, table.number = tableId, col.names = "pretty");
  # put in format for call to all_county_choropleth
  acs.df = data.frame(state  = geography(acs.data)$NAME, 
                      value = as.numeric(estimate(acs.data)));
  title  = acs.data@acs.colnames; 
  state_choropleth(acs.df, num_buckets, title, showLabels = showLabels);  
}

acs_all_zip_choropleth = function(tableId, num_buckets = 9)
{
  us.zip.code = geo.make(zip.code = "*")
  acs.data = acs.fetch(geography=us.zip.code, table.number = tableId, col.names = "pretty")
  
  # put in format for call to all_zip_choropleth
  acs.df = data.frame(zip  = geography(acs.data)$zipcodetabulationarea, 
                      value = as.numeric(estimate(acs.data)))
  title  = acs.data@acs.colnames
  
  acs.df = na.omit(acs.df) # surprisingly, this sometimes returns NA values
  
  zip_choropleth(acs.df, num_buckets, title)
}
