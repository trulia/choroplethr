incomeTableId = "B19301"
df = get_acs_df(incomeTableId, "county", 2011, 5)

one_percent = quantile(acs.df$value, probs=c(0, 0.01, 0.99, 1))
acs.df$value = cut2(acs.df$value, one_percent)
choropleth = county_choropleth_manual(acs.df)
choropleth + scale_fill_brewer()

acs.df$value2 = cut2(acs.df$value, one_percent)

choropleth$value = generate_values(choropleth$value, num_buckets);

choropleth + s

choroplethr_state
choroplethr(acs.df, d, num_buckets, title, "", showLabels, states=states);  
