
## ------------------------------------------------------------------------
library(choroplethr)
data(choroplethr)

head(df_pop_state)


## ------------------------------------------------------------------------
choroplethr(df_pop_state, "state", title="2012 State Population Estimates")


## ------------------------------------------------------------------------
head(df_pop_county)


## ------------------------------------------------------------------------
choroplethr(df_pop_county, "county", title="2012 County Population Estimates")


## ------------------------------------------------------------------------
head(df_pop_zip)


## ------------------------------------------------------------------------
choroplethr(df_pop_zip, "zip", title="2012 ZIP Code Tabulated Area (ZCTA) Population Estimates")


