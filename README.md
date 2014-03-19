# choroplethr
Master: [![Build Status](https://travis-ci.org/trulia/choroplethr.png?branch=master)](https://travis-ci.org/trulia/choroplethr)

`choroplethr` simplifies the creation of choropleths in R.  A choropleth is a thematic map where geographic regions such as states are colored according to some metric, such as which political party the state voted for.  `choroplethr` supports three levels of geographic resolution and three types of scales.  Common problems such as matching county data with map data, choosing and labeling discrete scales and creating a clean background are handled automatically. 

`choroplethr` provides native support for viewing data from the US Census's [American Community Survey (ACS)](https://www.census.gov/acs/www/).  

The `choroplethr` package is described more fully in the [wiki](https://github.com/trulia/choroplethr/wiki).

## Installation

To install the latest stable release type the following from an R console:

```
install.packages("choroplethr")
```

To install the development version use the `devtools` package:

```
# install.packages("devtools")
library(devtools)
install_github("choroplethr", "arilamstein")
library(choroplethr)
```
