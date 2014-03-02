library(gridExtra)

#States with less than or greater than 1M residents
df=get_acs_df("B01003", "state")
df.map=bind_df_to_map(df, "state")
df.map$value=cut2(df.map$value, cuts=c(0,1000000,Inf))
map.state.1m = render_choropleth(df.map, "state", "States with a population over 1M", "Population")
map.state.1m

#Counties with less than or greater than 1M residents
df=get_acs_df("B01003", "county")
df.map=bind_df_to_map(df, "county")
df.map$value=cut2(df.map$value, cuts=c(0,1000000,Inf))
map.county.1m = render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")
map.county.1m

grid.arrange(map.state.1m, map.county.1m, ncol=2)

# median age
df=get_acs_df("B01002", "zip")
df = df[df$value >= 50, ]
df.map=bind_df_to_map(df, "zip")
map.ny.zips = render_choropleth(df.map, 
                                "zip", 
                                title="NY Zip Codes by Age",
                                scaleName="Median Age",
                                states="NY") # show all zips
map.ny.zips

# show zips in NY state where the median age is >= the 75th percentile of all zips
summary(df$value)
df.map.ny.age = df.map[df.map$value >= 45.9, ]
df.map.ny.age$value = cut2(df.map.ny.age$value.bak, cuts=c(45, 55, 65, 75, 85, 95, 106))
map.ny.zips.subset = render_choropleth(df.map.ny.age, 
                                      "zip", 
                                      title="ZIP Codes in New York with Median Age Above the 75th Percentile",
                                      scaleName="Median Age", 
                                      states="NY")
map.ny.zips.subset

grid.arrange(map.ny.zips, map.ny.zips.subset, ncol=2)
