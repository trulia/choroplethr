## ----hold=TRUE-----------------------------------------------------------
library(choroplethr)

?df_pop_state
data(df_pop_state)

?state_choropleth
state_choropleth(df_pop_state)

## ------------------------------------------------------------------------
library(choroplethrMaps)

?state.regions
data(state.regions)
head(state.regions)

## ------------------------------------------------------------------------
state_choropleth(df_pop_state,
                 title   = "2012 Population Estimates",
                 legend  = "Population",
                 buckets = 1,
                 zoom    = c("california", "washington", "oregon"))

## ------------------------------------------------------------------------
library(ggplot2)

?df_president 
data(df_president)

choro = StateChoropleth$new(df_president)
choro$title = "2012 Election Results"
choro$ggplot_scale = scale_fill_manual(name="Candidate", values=c("blue", "red"))
choro$render()

