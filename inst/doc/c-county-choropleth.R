## ----hold=TRUE-----------------------------------------------------------
library(choroplethr)

?df_pop_county
data(df_pop_county)

?county_choropleth
county_choropleth(df_pop_county)

## ------------------------------------------------------------------------
library(choroplethrMaps)

?county.regions
data(county.regions)
head(county.regions)

## ------------------------------------------------------------------------
county_choropleth(df_pop_county,
                 title   = "2012 Population Estimates",
                 legend  = "Population",
                 buckets = 1,
                 zoom    = c("california", "washington", "oregon"))

## ------------------------------------------------------------------------
library(ggplot2)

choro = CountyChoropleth$new(df_pop_county)
choro$title = "2012 Population Estimates"
choro$ggplot_scale = scale_fill_brewer(name="Population", palette=2, drop=FALSE)
choro$render()

