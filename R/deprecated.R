#' Create a choropleth
#' 
#' This function is deprecated as of choroplethr version 2.0.0. Please use ?state_choropleth, 
#' ?county_choropleth, ?zip_map and ?country_choroplethr instead. The last version of choroplethr 
#' in which this function worked was version 1.7.0, which can be downloaded from CRAN 
#' here: http://cran.r-project.org/web/packages/choroplethr/index.html
#' 
#' @param
#' ... All arguments are ignored.
#' 
#' @export
choroplethr = function(...)  
{
  warning(paste("This function is deprecated as of choroplethr version 2.0.0.",
                "Please use ?state_choropleth, ?county_choropleth, ?zip_map and ?country_choroplethr instead.",
                "The last version of choroplethr in which this function worked was version 1.7.0, which can be downloaded",
                "from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
}

#' Create a map visualizing US ZIP codes with sensible defaults
#' 
#' This function is deprecated as of choroplethr version 3.0.0. Please use ?zip_choropleth instead. 
#' The last version of choroplethr 
#' in which this function worked was version 2.1.1, which can be downloaded from CRAN 
#' here: http://cran.r-project.org/web/packages/choroplethr/index.html
#' 
#' @param
#' ... All arguments are ignored.
#' 
#' @export
zip_map = function(...)
{
  warning(paste("This function is deprecated as of choroplethr version 3.0.0.",
                "Please use ?zip_choropleth instead.",
                "The last version of choroplethr in which this function worked was version 2.1.1, which can be downloaded",
                "from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
}

#' Create a choropleth of USA Counties, with sensible defaults, that zooms on counties.
#' 
#' This function is deprecated as of choroplethr version 3.0.0. Please use ?county_choropleth
#' with the county_zoom parameter set instead.  The last version of choroplethr 
#' in which this function worked was version 2.1.1, which can be downloaded from CRAN 
#' here: http://cran.r-project.org/web/packages/choroplethr/index.html
#' 
#' @param
#' ... All arguments are ignored.
#' 
#' @export
county_zoom_choropleth = function(...)
{
  warning(paste("This function is deprecated as of choroplethr version 2.1.1.",
                "Please use ?county_choropleth with the county_zoom parameter set instead.",
                "The last version of choroplethr in which this function worked was version 2.1.1, which can be downloaded",
                "from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
}

#' Create a choropleth from ACS data.
#' 
#' This function is deprecated as of choroplethr version 3.0.0. Please use ?state_choropleth_acs, 
#' ?county_choropleth_acs, ?zip_choropleth_acs. The last version of choroplethr 
#' in which this function worked was version 2.1.1, which can be downloaded from CRAN 
#' here: http://cran.r-project.org/web/packages/choroplethr/index.html
#'
#' @param
#' ... All arguments are ignored.
#'
#' @export
choroplethr_acs = function(...)
{
  warning(paste("This function is deprecated as of choroplethr version 3.0.0.",
                "Please use ?state_choropleth_acs, ?county_choropleth_acs and ?zip_choropleth_acs instead.",
                "The last version of choroplethr in which this function worked was version 2.1.1, which can be downloaded",
                "from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
}

#' Returns a data.frame representing US Census American Community Survey (ACS) estimates.
#' 
#' This function is deprecated as of choroplethr version 3.0.0. Please use ?get_acs_data instead.
#' The last version of choroplethr in which this functions worked was version 2.1.1, which can
#' be downloaded from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html
#' @param ... All arguments are ignored.
#' 
#' @export
get_acs_df = function(...)
{
  warning(paste("This function is deprecated as of choroplethr version 3.0.0. Please use ?get_acs_data instead.",
                "The last version of choroplethr in which this functions worked was version 2.1.1, which can",
                "from CRAN here: http://cran.r-project.org/web/packages/choroplethr/index.html"))
}  