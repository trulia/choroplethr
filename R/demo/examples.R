# example of state choropleth
df = data.frame(region=state.abb, value=sample(100, 50))
choroplethr(df, lod="state")

# example of county choropleth
df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=T))
choroplethr(df, "county", 2)

# example of zip map
data(zipcode)
df = zipcode
df$region = df$zip
df$value = sample(100, nrow(zipcode), replace=T)
choroplethr(df, "zip", 9)