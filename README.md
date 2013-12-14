# choroplethr

`choroplethr` is a set of functions to simply the creation of thematic maps (choropleths) in R.  In a choropleth regions (such as states) are colored according to some metric (such as which political party the state voted for).  Three levels of geographic resolution (US state, county and ZIP code) and two types of scales (continuous and discrete) are supported.  Common problems such as rendering/matching county data with map data, choosing and labeling discrete scales and creating a clean background are handled automatically, leaving more time to explore your data.  

`choroplethr` was originally created to support visualizing US census data and attempts to work seamlessly with the [acs](http://cran.r-project.org/web/packages/acs/) package.  

See the [wiki](https://github.com/arilamstein/choroplethr/wiki) for examples of `choroplethr` in action as well a discussion of the impact of various geographic and scale choices in map generation.

## Installation

To install the development version of choroplethr it's easiest to use the `devtools` package:

```
# install.packages("devtools")
library(devtools)
install_github("choroplethr", "arilamstein")
```

choroplethr is currently not available on CRAN.

## Usage

#### Creating a State Choropleth
To create a state choropleth call `all_state_choropleth` with a data.frame with one column named `state` and one column named `value`:
```
# requires a df with columns named "state" and "value"
all_state_choropleth(df_state, 
                    num_buckets = 9, 
                    title = "", 
                    roundLabel = T, 
                    showLabels = T,
                    scaleName = "")
```
The `num_buckets` argument is the most interesting.  Setting it to 1 will cause the scale to be continuous, 2 will highlight values above/below the median, and 9 will show the maximum resolution.  `showLabels` will optionally add state abbreviations.

#### Creating a County Choropleth
To create a county choropleth call `all_county_choropleth` with a data.frame with one column named `fips` and one column named `value`:
```
# given a dataframe with 2 columns, fips and value, create a choropleth of all counties in
# the contiguous 48 states
all_county_choropleth(df_fips, num_buckets=9, title="", roundLabel=T, scaleName="")
```
the fips column must represent county FIPS codes.

#### Creating a ZIP Code Choropleth
To create a ZIP code choropleth call `all_zip_choropleth` with a data.frame with one column named `zip` and one column named `value`:

```
# requires a df with columns named "zip" and "value"
all_zip_choropleth = function(df_zip, 
                                num_buckets = 9, 
                                title = "", 
                                roundLabel = T,
                                scaleName = "")
```

ZIP code choropleths are currently rendered as scatterplots.
