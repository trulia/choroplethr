if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("country.regions"))
}

#' Create a country-level choropleth using data from the World Bank's World Development Indicators (WDI)
#' 
#' @param code The WDI code to use.
#' @param year The year of data to use.
#' @param title A title for the map.  If not specified, automatically generated to include WDI code and year.
#' @param num_colors The number of colors to use on the map.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many colors. 
#' @param zoom An optional list of countries to zoom in on. Must come from the "name" column in
#' ?country.regions.
#'
#' @examples
#' \dontrun{
#' # See http://data.worldbank.org/indicator/SP.POP.TOTL
#' choroplethr_wdi(code="SP.POP.TOTL", year=2012, title="2012 Population Estimates", num_colors=1)
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
choroplethr_wdi = function(code="SP.POP.TOTL", year=2012, title="", num_colors=7, zoom=NULL)
{
  data(country.regions, package="choroplethrMaps", envir=environment())
  if (is.null(title))
  {
    title = paste0("WDI Indicator ", code, " for year ", year)    
  }

  data = WDI(country=country.regions$iso2c, code, start=year, end=year) 
  data = merge(data, country.regions)
  data$value = data[, names(data) == code] # choroplethr requires value column to be named "value"
  
  country_choropleth(data, title, "", num_colors, zoom)
}