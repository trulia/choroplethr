# code to transparently generate choropleths from the American Community Survey (ACS)
# using the acs package (http://cran.r-project.org/web/packages/acs/).
# The ACS stores data in tables.  A list of tableIds of the 2011 ACS can be found here:
# http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_11_5YR#

choroplethr_acs = function(tableId, lod, num_buckets = 9, showLabels = T)
{
  stopifnot(lod %in% c("state", "county", "zip"))
  stopifnot(num_buckets > 0 && num_buckets < 10)
  
  if (lod == "state") {
    # get census data for all states from specified table
    us.state = geo.make(state = "*");
    acs.data = acs.fetch(geography=us.state, table.number = tableId, col.names = "pretty");
    # put in format for call to all_county_choropleth
    acs.df = data.frame(region = geography(acs.data)$NAME, 
                        value  = as.numeric(estimate(acs.data)));
    title  = acs.data@acs.colnames; 
    choroplethr(acs.df, "state", num_buckets, title, showLabels);  
    
  } else if (lod == "county") {
    # get census data for all counties from specified table
    us.county = geo.make(state = "*", county = "*");
    acs.data  = acs.fetch(geography=us.county, table.number = tableId, col.names = "pretty");
    # create fips code
    acs.data@geography$fips = paste(as.character(acs.data@geography$state), 
                                    acs.data@geography$county, 
                                    sep = "");
    # put in format for call to all_county_choropleth
    acs.df = data.frame(region  = geography(acs.data)$fips, 
                        value = as.numeric(estimate(acs.data)));
    title  = acs.data@acs.colnames; 
    choroplethr(acs.df, "county", num_buckets, title);  
  } else if (lod == "zip") {
    us.zip.code = geo.make(zip.code = "*")
    acs.data = acs.fetch(geography=us.zip.code, table.number = tableId, col.names = "pretty")
    
    # put in format for call to choroplethr
    acs.df = data.frame(region = geography(acs.data)$zipcodetabulationarea, 
                        value  = as.numeric(estimate(acs.data)))
    title  = acs.data@acs.colnames
    
    acs.df = na.omit(acs.df) # surprisingly, this sometimes returns NA values
    
    choroplethr(acs.df, lod, num_buckets, title) 
  }
}

