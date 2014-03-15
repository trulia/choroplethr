context("factor input")

test_that("state level choropleths handle factor values", {
  df = data.frame(region=state.abb, value=sample(5, 50, replace=TRUE))
  df$value = factor(df$value)
  expect_is(choroplethr(df, lod="state"), "ggplot")
})

data(county.fips, package="maps")
test_that("county level choropleths handle factor values", {
  df = data.frame(region=county.fips$fips, value=sample(5, nrow(county.fips), replace=T))
  df$value = factor(df$value)
  expect_is(choroplethr(df, lod="county"), "ggplot")
})

data(zipcode, package="zipcode")
test_that("zip level choropleths handle factor values", {
  df = data.frame(region=zipcode$zip, value = sample(5, nrow(zipcode), replace=T))
  df$value = factor(df$value)
  expect_is(choroplethr(df, lod="zip"), "ggplot")
})
