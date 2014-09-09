#' Create a country-level choropleth using data from the World Bank Development Indicators (WDI).
#' 
#' @param code The WDI code to use.
#' @param year The year of data to use.
#' @param title A title for the map.  If not specified, automatically generated to include WDI code and year.
#' @param countries If null, render all countries. Otherwise must be a vector of country names.  See ?country.names for a list of valid country names.
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets.  For
#' example, 2 will show values above or below the median, and 9 will show the maximum
#' resolution.  Defaults to 9.

#' @return A choropleth.
#' 
#' @export
#' @importFrom WDI WDI
choroplethr_wdi = function(code="SP.POP.TOTL", year=2012, title=NULL, countries=NULL, num_buckets=9)
{
  if (is.null(title))
  {
    title = paste0("WDI indicator ", code, " for year ", year)    
  }
  
  data(country.names, package="choroplethr", envir=environment())
  if (!is.null(countries))
  {
    stopifnot(countries %in% country.names$region)
    stopifnot(!any(duplicated(countries)))
  } else {
    countries = country.names$region
  }
  
  data = WDI(country=country.names$iso2c, code, start=year, end=year) 
  data = merge(data, country.names)
  data$value = data[, names(data) == code] # choroplethr requires value column to be named "valued"
  
  choroplethr(data, "world", title=title, countries=countries, num_buckets=num_buckets)
}