# choroplethr
Master: [![Build Status](https://travis-ci.org/trulia/choroplethr.png?branch=master)](https://travis-ci.org/trulia/choroplethr)

`choroplethr` simplifies the creation of choropleths in R.  A choropleth is a thematic map where geographic regions such as states are colored according to some metric, such as which political party the state voted for.  `choroplethr` is built on top of the [ggplot2](http://ggplot2.org/) graphics library and is supports three levels of geographic resolution and three types of scales.  Common problems such as matching county data with map data, choosing and labeling discrete scales and creating a clean background are handled automatically. 

`choroplethr` provides native support for viewing data from the US Census's [American Community Survey (ACS)](https://www.census.gov/acs/www/).  

`choropleth` also supports animating choropleths, which is useful for seeing trends in regions over time, such as population changes.

The `choroplethr` package is described more fully in the following wiki pages:
1. [[What is a choropleth?  When should I use one?]]
1. [[Choosing a Level of Detail (lod)]]
1. [[Choosing a Scale Type]]
1. [[Mapping Census Data]]
1. [[Animated Choropleths]]
1. [[ZIP Level Maps]]

## Installation

To install the latest stable release type the following from an R console:

```
install.packages("choroplethr")
```

To install the development version use the `devtools` package:

```
# install.packages("devtools")
library(devtools)
install_github("choroplethr", "trulia")
library(choroplethr)
```
