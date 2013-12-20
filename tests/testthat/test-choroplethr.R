# rendering a test state-level map at the continuous and discrete scales needs to return a valid ggplot object
df = data.frame(region=state.abb, value=sample(100, 50))
expect_equal(class(choroplethr(df, lod="state", num_buckets=1)), c("gg", "ggplot"))
expect_that(choroplethr(df, lod="state", num_buckets=9), matches(c("gg", "ggplot")))
                        
# rendering a test county-level map at the continuous and discrete scales needs to return a valid ggplot object
df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=T))
expect_that(choroplethr(df, lod="county", num_buckets=1), matches(c("gg", "ggplot")))
expect_that(choroplethr(df, lod="county", num_buckets=9), matches(c("gg", "ggplot")))

# do I need data(zipcode) here?
# rendering a test zip-level map at the continuous and discrete scales needs to return a valid ggplot object
df = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=T))
expect_that(choroplethr(df, lod="zip", num_buckets=1), matches(c("gg", "ggplot")))
expect_that(choroplethr(df, lod="zip", num_buckets=9), matches(c("gg", "ggplot")))
