## ----hold=TRUE-----------------------------------------------------------
library(choroplethr)

?df_pop_zip
data(df_pop_zip)

?zip_map
zip_map(df_pop_zip)

## ------------------------------------------------------------------------
library(zipcode)

?zipcode
data(zipcode)
head(zipcode)

## ------------------------------------------------------------------------
zip_map(df_pop_zip,
        title   = "2012 Population Estimates",
        legend  = "Population",
        buckets = 1,
        zoom    = c("california", "washington", "oregon"))

## ------------------------------------------------------------------------
library(ggplot2)

choro = ZipMap$new(df_pop_zip)
choro$title = "2012 Population Estimates"
choro$ggplot_scale = scale_color_brewer(name="Population", palette=2, drop=FALSE)
choro$render()

