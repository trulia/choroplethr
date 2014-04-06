
## ------------------------------------------------------------------------
library(choroplethr)
data(choroplethr)
choroplethr(df_pop_state, "state", num_buckets=1, title="2012 State Population Estimates, Continuous Scale") 


## ------------------------------------------------------------------------
library(ggplot2)
library(scales)
ggplot(df_pop_state, aes(factor(1), value)) + 
  geom_boxplot() + 
  ggtitle("Boxplot of 2012 State Population Estimates") + 
  scale_y_continuous(label=comma)


## ------------------------------------------------------------------------
choroplethr(df_pop_state, "state", num_buckets=9, title="2012 State Population Estimates, 9 Buckets") 


## ------------------------------------------------------------------------
choroplethr(df_pop_state, "state", num_buckets=2, title="2012 State Population Estimates, 2 Buckets") 


## ------------------------------------------------------------------------
library(Hmisc) # for cut2
df_pop_state$value = cut2(df_pop_state$value, cuts=c(0,1000000,Inf))
choroplethr(df_pop_state, "state", title="States with Populations Above or Below 1 Million")


