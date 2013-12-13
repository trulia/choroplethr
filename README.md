# choroplethr

choroplethr is a set of functions for conveniently drawing choropleths in R.  Choropleths are thematic maps where regions (eg. states) are colored according to some metric (eg. which political party the state voted for).  choroplethr currently supports three levels of geographic resolution in the US: state, county and ZIP code.  Common problems such as rendering/matching county data with map data, choosing scales, creating labels and creating a clean background are handled automatically, making it easier to explore your data.

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