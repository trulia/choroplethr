data(choroplethr)
s = StateChoropleth$new(df_pop_state)
s$render()

s
s$prepare_map()
head(s$choropleth.df)
