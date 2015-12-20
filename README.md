# choroplethr
<!--
commented out because travis's r support is erroneously failing:
https://github.com/Rexamine/stringi/issues/155
Master: [![Build Status](https://travis-ci.org/arilamstein/choroplethr.png?branch=master)](https://travis-ci.org/arilamstein/choroplethr)
-->
choroplethr simplifies the creation of choropleth maps in R. Choropleths are thematic maps where geographic regions, such as states, are colored according to some metric, such as the number of people who live in that state.  choroplethr simplifies this process by
    
1. Providing ready-made functions for creating choropleths using 220 different maps.
2. Providing API connections to interesting data sources for making choropleths.
3. Providing a framework for creating choropleths from arbitrary shapefiles.

## Training & Development

My free course [Learn to Map Census Data in R](http://www.arilamstein.com/free-course) can teach you how to use this package. There is also a [paid course](http://courses.arilamstein.com/courses/mapmaking-r-choroplethr) that goes into much more detail. I blog about this package's development [here](http://www.arilamstein.com/blog).

## Documentation

Please see the following pages for more details.

1. [Introduction](http://cran.r-project.org/web/packages/choroplethr/vignettes/a-introduction.html)
1. [US State Choropleths](http://cran.r-project.org/web/packages/choroplethr/vignettes/b-state-choropleth.html)
1. [US County Choropleths](http://cran.r-project.org/web/packages/choroplethr/vignettes/c-county-choropleth.html)
1. [Country Choropleths](http://cran.r-project.org/web/packages/choroplethr/vignettes/d-country-choropleth.html)
1. [Mapping US Census Data](http://cran.r-project.org/web/packages/choroplethr/vignettes/e-mapping-us-census-data.html)
1. [Mapping World Bank WDI Data](http://cran.r-project.org/web/packages/choroplethr/vignettes/f-world-bank-data.html)
1. [Animated Choropleths](http://cran.r-project.org/web/packages/choroplethr/vignettes/g-animated-choropleths.html)
1. [Creating Your Own Maps](http://cran.r-project.org/web/packages/choroplethr/vignettes/h-creating-your-own-maps.html)
2. [Creating Administrative Level 1 Maps](http://cran.r-project.org/web/packages/choroplethr/vignettes/i-creating-admin1-maps.html)

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
