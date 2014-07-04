context("choroplethr")

test_that("state level choropleths return ggplots with discrete and continuous lods", {
  df = data.frame(region=state.abb, value=sample(100, 50))
  expect_is(choroplethr(df, lod="state", num_buckets=1), "ggplot")
  expect_is(choroplethr(df, lod="state", num_buckets=9), "ggplot")
})

data(county.names, package="choroplethr")
test_that("county level choropleths return ggplots at discrete and continuous lods", {
  df = data.frame(region=county.names$county.fips.character, value=sample(100, length(county.names$county.fips.character), replace=T))
  expect_is(choroplethr(df, lod="county", num_buckets=1, warn_na=FALSE), "ggplot")
  expect_is(choroplethr(df, lod="county", num_buckets=9, warn_na=FALSE), "ggplot")
})

data(zipcode, package="zipcode")
test_that("zip level choropleths return ggplots at discrete and continuous lods", {  
  df = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=T))
  expect_is(choroplethr(df, lod="zip", num_buckets=1), "ggplot")
  expect_is(choroplethr(df, lod="zip", num_buckets=9), "ggplot")
})

test_that("county level choropleths handle leading zeros for states", {
  # los angeles and san francisco
  df = data.frame(region=c("06037", "06075"), value=c(200,100))
  expect_is(choroplethr(df, lod="county", num_buckets=1, warn_na=FALSE), "ggplot")
  expect_is(choroplethr(df, lod="county", num_buckets=2, warn_na=FALSE), "ggplot")
})

