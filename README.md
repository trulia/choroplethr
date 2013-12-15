# choroplethr

`choroplethr` simplifies the creation of choropleths in R.  A choropleth is a thematic map where geographic regions such as states are colored according to some metric, such as which political party the state voted for.  `choroplethr` supports three levels of geographic resolution and two types of scales.  Common problems such as matching county data with map data, choosing and labeling discrete scales and creating a clean background are handled automatically. 

`choroplethr` was originally created to support visualizing US census data and attempts to work seamlessly with the [acs](http://cran.r-project.org/web/packages/acs/) package.  

See the [wiki](https://github.com/arilamstein/choroplethr/wiki) for examples of `choroplethr` in action as well as a discussion of the impact of various geographic and scale choices in map generation.

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

The third parameter, `num_buckets`, specifies a continuous scale (if 1) or a discrete scale (if in the range [2, 9]).  For discrete scales `choroplethr` will create `num_buckets` equally sized buckets.

### The `choroplethr_acs` function

`choroplethr` was originally created to facilitate viewing data collected by the US Census Bureau - specifically the [American Community Survey (ACS)](https://www.census.gov/acs/www/).  ACS data is referenced by table id.  For example, the list of 2007-2011 American Community Survey 5-Year Estimates, with corresponding table ids, can be accessed [here](http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_11_5YR#).  Then you can make a choroplethr of ACS data with the `choroplethr_acs` function like this:

```
# total population, state level
choroplethr_acs("B00001", "state", 1);

# total population, county level, above and below median
choroplethr_acs("B00001", "county", 2); 

# per capita income, zip code, continuous scale
choroplethr_acs("B19301", "zip");
```

To use `choroplethr_acs` you must have the [acs package](http://cran.r-project.org/web/packages/acs/) installed, acquired a [Census API key](http://www.census.gov/developers/tos/key_request.html), and stored your with the the acs's `api.key.install` function.
