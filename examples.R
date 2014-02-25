#States with less than or greater than 1M residents
df=get_acs_df("B01003", "state", 2012,5)
df.map=bind_df_to_state_map(df)
df.map$value=cut2(df.map$value, cuts=c(0,1000000,Inf))
render_state_choropleth(df.map)

#Counties with less than or greater than 1M residents
df=get_acs_df("B01003", "county", 2012,5)
df.map=bind_df_to_county_map(df)
df.map$value=cut2(df.map$value, cuts=c(0,1000000,Inf))
render_county_choropleth(df.map)
