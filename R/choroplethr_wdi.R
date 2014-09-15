#' Create a country-level choropleth using data from the World Bank's World Development Indicators (WDI).
#' 
#' @param code The WDI code to use.
#' @param year The year of data to use.
#' @param title A title for the map.  If not specified, automatically generated to include WDI code and year.
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets.  For
#' example, 2 will show values above or below the median, and 9 will show the maximum
#' resolution.  Defaults to 9.
#' @param zoom An optional list of countries to zoom in on. Must come from the "name" column in
#' ?country.names.
#'
#' @examples
#' \dontrun{
#' # See http://data.worldbank.org/indicator/SP.POP.TOTL
#' choroplethr_wdi(code="SP.POP.TOTL", year=2012, title="2012 Per Capita Income", num_buckets=1)
#'
#' # See http://data.worldbank.org/indicator/SP.DYN.LE00.IN 
#' choroplethr_wdi(code="SP.DYN.LE00.IN", year=2012, title="2012 Life Expectancy Estimates")
#'
#' # See http://data.worldbank.org/indicator/NY.GDP.PCAP.CD 
#' choroplethr_wdi(code="NY.GDP.PCAP.CD", year=2012, title="2012 Per Capita Income") 
#' }
#' 
#' @return A choropleth.
#' 
#' @references Uses the WDI function from the WDI package by Vincent Arel-Bundock.
#' @export
#' @importFrom WDI WDI
choroplethr_wdi = function(code="SP.POP.TOTL", year=2012, title="", num_buckets=7, zoom=NULL)
{
  if (is.null(title))
  {
    title = paste0("WDI Indicator ", code, " for year ", year)    
  }

  data = WDI(country=country.names$iso2c, code, start=year, end=year) 
  data = merge(data, country.names)
  data$value = data[, names(data) == code] # choroplethr requires value column to be named "value"
  
  country_choropleth(data, title, "", num_buckets, zoom)
}