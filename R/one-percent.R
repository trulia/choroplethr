# get the data
incomeTableId = "B19301"
acs.df = get_acs_df(incomeTableId, "county", 2011, 5) # TODO: EXPORT FUNCTION!

# bind it to a map
acs.df = bind_df_to_county_map(acs.df) # TODO: EXPORT FUNCTION!

# determine how I want to discretize the values
one_percent = quantile(acs.df$value, probs=c(0, 0.10, 0.90, 1))
acs.df$value = cut2(acs.df$value, one_percent)

# render the map!
render_county_choropleth(acs.df) # TODO: EXPORT FUNCTION!

# TODO make sure that the main choroplethr and choroplethr_acs functions still work!
# TODO: create pivotal stories for all these tasks

# TODO: Repeat this for state and zip

# Then write any necessary tests and release