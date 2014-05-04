context("bind_df_to_map")

test_that("state df gets bound to map",
{
  df = data.frame(region=state.abb, value=sample(100, 50))
  df.map = bind_df_to_map(df, "state")
  expect_equal(15537, nrow(df.map))
})

test_that("county df gets bound to map", {
  data(county.fips, package="maps")
  df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=TRUE))
  df.map = bind_df_to_map(df, "county")
  expect_equal(88678, nrow(df.map))
})

test_that("zip df gets bound to map", {
  data(zipcode, package="zipcode", envir=environment())
  df = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=TRUE))
  df.map = bind_df_to_map(df, "zip")
  expect_equal(42714, nrow(df.map))
})