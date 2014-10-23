## ----hold=TRUE-----------------------------------------------------------
library(choroplethr)

?df_pop_country
data(df_pop_country)

?country_choropleth
country_choropleth(df_pop_country)

## ------------------------------------------------------------------------
library(choroplethrMaps)

?country.regions
data(country.regions)
head(country.regions)

## ------------------------------------------------------------------------
country_choropleth(df_pop_country,
                 title   = "2012 Population Estimates",
                 legend  = "Population",
                 buckets = 1,
                 zoom    = c("united states of america", "mexico", "canada"))

## ------------------------------------------------------------------------
library(ggplot2)

choro = CountryChoropleth$new(df_pop_country)
choro$title = "2012 Population Estimates2012 Election Results"
choro$ggplot_scale = scale_fill_brewer(name="Population", palette=2)
choro$render()

