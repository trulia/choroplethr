# This file contains examples of state and county choropleths using data from 
# the American Community Survey (ACS) which is run by the US Census Department.
# See https://www.census.gov/acs/www/ for details of the ACS.
# See the "acs" package on CRAN for details about getting data from the ACS 
# survey in R: http://cran.r-project.org/web/packages/acs/.

library(acs)
#source('county.R')
#source('state.R')

# The census stores data in tables.  A list of tableIds of the 2011 ACS can be found here:
# http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_11_5YR#
# Some popular ones tables
# B00001 UNWEIGHTED SAMPLE COUNT OF THE POPULATION 
# B19301  PER CAPITA INCOME IN THE PAST 12 MONTHS (IN 2011 INFLATION-ADJUSTED DOLLARS) 

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

gen_choropleths = function(tableId)
{
  # some useful county choropleths
  print(acs_all_county_choropleth(tableId, num_buckets = 1)); # continuous scale 
  print(acs_all_county_choropleth(tableId, num_buckets = 2)); # buckets show above/below median
  print(acs_all_county_choropleth(tableId, num_buckets = 9)); # 9 equal sized buckets - max resolution
  
  # some useful state choropleths
  print(acs_all_state_choropleth(tableId, num_buckets = 1, showLabels = T)); # continuous scale, with state labels
  print(acs_all_state_choropleth(tableId, 2, F)); # buckets show above/below median, no labels
  print(acs_all_state_choropleth(tableId, 9, T)); # 9 equal sized buckets (max resolution), with labels

  # some useful zip choropleths
  print(acs_all_zip_choropleth(tableId, num_buckets = 1)); # continuous scale
  print(acs_all_zip_choropleth(tableId, num_buckets = 2)); # buckets show above/below median
  print(acs_all_zip_choropleth(tableId, num_buckets = 9)); # 9 equal sized buckets (max resolution)
}

# The idea here is that, like a 5 number summary for values, these bucket sizes are useful for 
# viewing choropleths.  
# 1 bucket (continuous scale) shows extremes.  For example, a choropleth of state populations vividly shows 
# the discrepancy between California and its neighbors
# 2 buckets show above and below the median, which is useful because in the previous map all the midwest states
# appeared so dark (because they were on the same sale as California
# 9 buckets shows the maximum resolution in the Brewer color palette
# TODO: It would be nice to have each of these maps share the same title.
print_3_maps = function(m1, m2, m3)
{
  grid.arrange(m1, m2, m3, nrow=3,ncol=1);
}  

print_3_maps(
  acs_all_state_choropleth(tableId, num_buckets = 1), # continuous scale
  acs_all_state_choropleth(tableId, num_buckets = 2), # buckets show above/below median
  acs_all_state_choropleth(tableId, num_buckets = 9)  # 9 equal sized buckets (max resolution)
);
  
# total population
gen_choropleths("B00001");
# per capita income
gen_choropleths("B19301");