context("choroplethr")

# rendering a test state-level map at the continuous and discrete scales needs to return a valid ggplot object
test_that("state level choropleths return ggplots with discrete and continuous lods", {
  df = data.frame(region=state.abb, value=sample(100, 50))
  expect_that(class(choroplethr(df, lod="state", num_buckets=1)), matches(c("gg", "ggplot")))
  expect_that(class(choroplethr(df, lod="state", num_buckets=9)), matches(c("gg", "ggplot")))
})
                        
# rendering a test county-level map at the continuous and discrete scales needs to return a valid ggplot object
data(county.fips, package="maps")
test_that("county level choropleths return ggplots at discrete and continuous lods", {
  df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=T))
  expect_that(class(choroplethr(df, lod="county", num_buckets=1)), matches(c("gg", "ggplot")))
  expect_that(class(choroplethr(df, lod="county", num_buckets=9)), matches(c("gg", "ggplot")))
})

# do I need data(zipcode) here?
# rendering a test zip-level map at the continuous and discrete scales needs to return a valid ggplot object
data(zipcode, package="zipcode")
test_that("zip level choropleths return ggplots at discrete and continuous lods", {  
  df = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=T))
  expect_that(class(choroplethr(df, lod="zip", num_buckets=1)), matches(c("gg", "ggplot")))
  expect_that(class(choroplethr(df, lod="zip", num_buckets=9)), matches(c("gg", "ggplot")))
})
