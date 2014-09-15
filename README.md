# choroplethr
Master: [![Build Status](https://travis-ci.org/trulia/choroplethr.png?branch=master)](https://travis-ci.org/trulia/choroplethr)
Dev: [![Build Status](https://travis-ci.org/trulia/choroplethr.png?branch=dev)](https://travis-ci.org/trulia/choroplethr)

`choroplethr` simplifies the creation of choropleths in R.  A choropleth is a thematic map where geographic regions, such as states, are colored according to some metric, such as the number of people who live in that state.  choroplethr provides:

2. An easy interface for creating choropleths using four popular maps (US States, US Counties, US Zips and Countries of the world).
3. Support for creating choropleths from two popular APIs (US Census Bureau and World Bank)
1. A framework for creating choropleths from arbitrary shapefiles.

j

1. [What is a choropleth?  When should I use one?](https://github.com/trulia/choroplethr/wiki/What-is-a-choropleth%3F--When-should-I-use-one%3F)
1. [Choosing a Level of Detail (lod)](https://github.com/trulia/choroplethr/wiki/Choosing-a-Level-of-Detail-%28lod%29)
1. [Choosing a Scale Type](https://github.com/trulia/choroplethr/wiki/Choosing-a-Scale-Type)
1. [Mapping Census Data](https://github.com/trulia/choroplethr/wiki/Mapping-Census-Data)
1. [Animated Choropleths](https://github.com/trulia/choroplethr/wiki/Animated-Choropleths)
1. [ZIP Level Maps](https://github.com/trulia/choroplethr/wiki/ZIP-Level-Maps)

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
