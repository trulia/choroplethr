## ----hold=TRUE, warning=FALSE, message=FALSE-----------------------------
library(choroplethr)
library(choroplethrMaps)
library(R6)
library(Hmisc)
library(stringr)
library(dplyr)
library(scales)
library(ggplot2)

# create the class, inheriting from the base Choropleth object
CountryChoropleth = R6Class("CountryChoropleth",
  inherit = choroplethr:::Choropleth,
  public = list(
    
    # initialize with a world map
    initialize = function(user.df)
    {
      data(country.map, package="choroplethrMaps")
      super$initialize(country.map, user.df)
    }
  )
)

# create some sample data and then render it
data(country.regions, package="choroplethrMaps")
df = data.frame(region=country.regions$region, value=sample(1:nrow(country.regions)))
c  = CountryChoropleth$new(df)
c$render()

## ------------------------------------------------------------------------
country_choropleth

