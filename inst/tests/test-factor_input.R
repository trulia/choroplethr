context("factor input")

test_that("state level choropleths handle factor values", {
  df = data.frame(region=state.abb, value=sample(5, 50, replace=TRUE))
  df$value = factor(df$value)
  expect_is(choroplethr(df, lod="state"), "ggplot")
})

data(county.names, package="choroplethr")
test_that("county level choropleths handle factor values", {
  df = data.frame(region=county.names$county.fips.character, value=sample(5, length(county.names$county.fips.character), replace=T))
  df$value = factor(df$value)
  expect_is(choroplethr(df, lod="county", warn_na=FALSE), "ggplot")
})

data(zipcode, package="zipcode")
test_that("zip level choropleths handle factor values", {
  df = data.frame(region=zipcode$zip, value = sample(5, nrow(zipcode), replace=T))
  df$value = factor(df$value)
  expect_is(choroplethr(df, lod="zip"), "ggplot")
})
