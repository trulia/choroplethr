#' Create a choropleth
#' 
#' Creates a choropleth from a specified data.frame and level of detail.
#'
#' This function is deprecated as of choroplether version 2.0.0. Please use ?state_choropleth, 
#' ?county_choropleth, ?zip_map and ?country_choroplethr instead. The last version of choroplethr 
#' in which this function worked was version 1.7.0, which can be downloaded from CRAN 
#' here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
#' 
#' @export
choroplethr = function(...)  
{
  warning(paste("This function is deprecated as of choroplether version 2.0.0.",
                "Please use ?state_choropleth, ?county_choropleth, ?zip_map and ?country_choroplethr instead.",
                "The last version of choroplethr in which this function worked was version 1.7.0, which can be downloaded",
                "from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
}