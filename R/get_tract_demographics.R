#' @importFrom acs acs.fetch geo.make
get_tracts_by_state = function(state_fips)
{
  counties = acs.fetch(geography    = geo.make(state = state_fips, county = "*"), 
                       table.number = "B01003",
                       endyear      = 2015)
  
  geo.make(state  = state_fips, 
           county = as.numeric(geography(counties)[[3]]), 
           tract  = "*")
}

#' @importFrom acs acs.fetch geo.make
get_tracts_by_state_and_county = function(state_fips, county_fips)
{
  stopifnot(!is.null(county_fips))
  
  # choroplethr requires users to use a numeric form of county fips codes.
  # but acs package here requires the county argument here to be just the 
  # 3 digit county part of the fips code.
  # Manhattan is 61, not 36061
  county_fips = as.character(county_fips)
  len         = nchar(county_fips)
  county_fips = substr(county_fips, len-2, len)
  county_fips = as.numeric(county_fips)
  
  counties = acs.fetch(geography    = geo.make(state = state_fips, county = county_fips), 
                       table.number = "B01003",
                       endyear      = 2015)
  
  geo.make(state  = state_fips, 
           county = as.numeric(geography(counties)[[3]]), 
           tract  = "*")
}

#' Get a handful of demographic variables on Census Tracts in a State from the US Census Bureau as a data.frame.
#' 
#' The data comes from the American Community Survey (ACS). The variables are: total population, percent White 
#' not Hispanic, Percent Black or African American not Hispanic, percent Asian not Hispanic,
#' percent Hispanic all races, per-capita income, median rent and median age.
#' @param state_name The name of the state. See ?state.regions for proper spelling and capitalization.
#' @param county_fips An optional vector of county fips codes within the state. Useful to set because getting data on all tracts can be slow.
#' @param endyear The end year for the survey
#' @param span The span of the survey
#' @references The choroplethr guide to Census data: http://www.arilamstein.com/open-source/choroplethr/mapping-us-census-data/
#' @references A list of all ACS Surveys: http://factfinder.census.gov/faces/affhelp/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS
#' @importFrom acs geo.make acs.fetch geography estimate
#' @importFrom utils data
#' @importFrom acs acs.fetch
#' @export
get_tract_demographics = function(state_name, county_fips = NULL, endyear=2013, span=5)
{  
  state_fips = get_state_fips_from_name(state_name)
  
  if (is.null(county_fips)) {
    tracts = get_tracts_by_state(state_fips)
  } else {
    tracts = get_tracts_by_state_and_county(state_fips, county_fips)
  }
  
  race.data = acs::acs.fetch(geography    = tracts, 
                             table.number = "B03002", 
                             col.names    = "pretty", 
                             endyear      = endyear, 
                             span         = span)
  
  # dummy to get proper regions
  dummy.df = convert_acs_obj_to_df("tract", race.data, 1, FALSE)
  
  # convert to a data.frame 
  df_race = data.frame(region                   = dummy.df$region,  
                       total_population         = as.numeric(acs::estimate(race.data[,1])),
                       white_alone_not_hispanic = as.numeric(acs::estimate(race.data[,3])),
                       black_alone_not_hispanic = as.numeric(acs::estimate(race.data[,4])),
                       asian_alone_not_hispanic = as.numeric(acs::estimate(race.data[,6])),
                       hispanic_all_races       = as.numeric(acs::estimate(race.data[,12])))
  
  df_race$region = as.character(df_race$region) # no idea why, but it's a factor before this line
  
  df_race$percent_white    = round(df_race$white_alone_not_hispanic / df_race$total_population * 100)
  df_race$percent_black    = round(df_race$black_alone_not_hispanic / df_race$total_population * 100)
  df_race$percent_asian    = round(df_race$asian_alone_not_hispanic / df_race$total_population * 100)
  df_race$percent_hispanic = round(df_race$hispanic_all_races       / df_race$total_population * 100)
  
  df_race = df_race[, c("region", "total_population", "percent_white", "percent_black", "percent_asian", "percent_hispanic")]
  
  # per capita income 
  df_income = get_tract_acs_data(tracts, "B19301", endyear=endyear, span=span)[[1]]   
  colnames(df_income)[[2]] = "per_capita_income"
  
  # median rent
  df_rent = get_tract_acs_data(tracts, "B25058", endyear=endyear, span=span)[[1]]  
  colnames(df_rent)[[2]] = "median_rent"
  
  # median age
  df_age = get_tract_acs_data(tracts, "B01002", endyear=endyear, span=span, column_idx=1)[[1]]  
  colnames(df_age)[[2]] = "median_age"
  
  df_demographics = merge(df_race        , df_income, all.x=TRUE)
  df_demographics = merge(df_demographics, df_rent  , all.x=TRUE)  
  df_demographics = merge(df_demographics, df_age   , all.x=TRUE)
  
  # making the region numeric is the easiest way to handle leading 0's
  df_demographics$region = as.numeric(df_demographics$region)

  df_demographics
}