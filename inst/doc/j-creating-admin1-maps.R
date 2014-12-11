## ------------------------------------------------------------------------
library(choroplethrAdmin1)
?admin1.map

## ------------------------------------------------------------------------
library(choroplethr)
?df_japan_census
data(df_japan_census)
head(df_japan_census)

## ------------------------------------------------------------------------
head(get_admin1_countries())

## ------------------------------------------------------------------------
head(get_admin1_regions("japan"))

## ------------------------------------------------------------------------
admin1_map("japan")

## ------------------------------------------------------------------------
df_japan_census$value = df_japan_census$pop_2010

## ------------------------------------------------------------------------
library(choroplethr)
?admin1_choropleth
admin1_choropleth(country.name = "japan", 
                  df           = df_japan_census, 
                  title        = "2010 Japan Population Estimates", 
                  legend       = "Population", buckets=1)

## ------------------------------------------------------------------------
kansai = c("mie", "nara", "wakayama", "kyoto", "osaka", "hyogo", "shiga")
admin1_choropleth(country.name = "japan", 
                  df           = df_japan_census, 
                  title        = "2010 Japan Population Estimates - Kansai Region", 
                  legend       = "Population", 
                  buckets      = 1, 
                  zoom         = kansai)

