# choroplethr

`choroplethr` simplifies the creation of choropleths in R.  A choropleth is a thematic map where geographic regions such as states are colored according to some metric, such as which political party the state voted for.  `choroplethr` supports three levels of geographic resolution and two types of scales.  Common problems such as matching county data with map data, choosing and labeling discrete scales and creating a clean background are handled automatically. 

`choroplethr` was originally created to support visualizing US census data and attempts to work seamlessly with the [acs](http://cran.r-project.org/web/packages/acs/) package.  

See the [wiki](https://github.com/arilamstein/choroplethr/wiki) for examples of `choroplethr` in action as well a discussion of the impact of various geographic and scale choices in map generation.

## Installation

To install the development version of `choroplethr` use the `devtools` package:

```
# install.packages("devtools")
library(devtools)
install_github("choroplethr", "arilamstein")
```

`choroplethr` is currently not available on CRAN.

## Usage

### The `choroplethr` function

The `choroplethr` function creates choropleths from user-supplied data.  The first parameter is a data.frame containing a column named `region` and a column named `value`.  The second parameter specifies the level of detail of the data and must be one of `state`, `county` or `zip`.  There are other, optional parameters as well.  Here are some examples of using `choroplethr` to create maps at the state, county and zip level.

```
# a state choropleth
df = data.frame(region=state.abb, value=sample(100, 50))
choroplethr(df, lod="state")

# a county choropleth
df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=T))
choroplethr(df, "county", 2)

# a zip choropleth 
data(zipcode)
df = data.frame(region=zipcode$zi, value = sample(100, nrow(zipcode), replace=T))
choroplethr(df, "zip", 9)
```

### The `choroplethr_acs` function

`choroplethr` is a 
#### Creating a choropleth of ACS data

The [American Community Survey (ACS)](https://www.census.gov/acs/www/) is an ongoing survey conducted by the Census Bureau.  It differs from the decennial census in two important ways.  First, it samples a small portion of the population each year, whereas the decennial census attempts to perform a complete count.  This leads to results (such as population counts) being estimates with margins of error and confidence intervals as opposed to single numbers.  Second, it asks much more detailed demographic information than the decennial census.  

ACS data is accessed by table id.  For example, the list of 2007-2011 American Community Survey 5-Year Estimates, with corresponding table ids, can be accessed [here](http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_11_5YR#).  To create a choropleth of an ACS table you only need to provide the tableId to one of these three functions:

```
acs_all_state_choropleth(tableId, num_buckets = 9, showLabels = T)
acs_all_county_choropleth(tableId, num_buckets = 9)
acs_all_zip_choropleth(tableId, num_buckets = 9)
```
