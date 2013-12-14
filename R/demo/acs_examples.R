# This file contains examples of state and county choropleths using data from 
# the American Community Survey (ACS) which is run by the US Census Department.
# See https://www.census.gov/acs/www/ for details of the ACS.
# See the "acs" package on CRAN for details about getting data from the ACS 
# survey in R: http://cran.r-project.org/web/packages/acs/.
# Some popular tables
# B00001 UNWEIGHTED SAMPLE COUNT OF THE POPULATION 
# B19301  PER CAPITA INCOME IN THE PAST 12 MONTHS (IN 2011 INFLATION-ADJUSTED DOLLARS) 

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

#acs_all_zip_choropleth("B00001", num_buckets = 2); # buckets show above/below median