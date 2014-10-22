# choroplethr
Master: [![Build Status](https://travis-ci.org/trulia/choroplethr.png?branch=master)](https://travis-ci.org/trulia/choroplethr)
Dev: [![Build Status](https://travis-ci.org/trulia/choroplethr.png?branch=dev)](https://travis-ci.org/trulia/choroplethr)

choroplethr simplifies the creation of choropleth maps in R. Choropleths are thematic maps where geographic regions, such as states, are colored according to some metric, such as the number of people who live in that state.  choroplethr simplifies this process by
    
1. Providing ready-made functions for creating choropleths using four different maps.
2. Providing API connections to interesting data sources for making choropleths.
3. Providing a framework for creating choropleths from arbitrary shapefiles.

Please see the following pages for more details.

1. [Introduction](https://github.com/trulia/choroplethr/wiki/Introduction)
1. [US State Choropleths](https://github.com/trulia/choroplethr/wiki/US-State-Choropleths)
1. [US County Choropleths](https://github.com/trulia/choroplethr/wiki/US-County-Choropleths)
1. [US ZIP Maps](https://github.com/trulia/choroplethr/wiki/US-ZIP-Maps)
1. [Country Choropleths]()
1. [Mapping US Census Data](https://github.com/trulia/choroplethr/wiki/Mapping-Census-Data)
1. [Mapping World Bank WDI Data]()
1. [Animated Choropleths](https://github.com/trulia/choroplethr/wiki/Animated-Choropleths)
1. [Creating Your Own Maps]()

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
