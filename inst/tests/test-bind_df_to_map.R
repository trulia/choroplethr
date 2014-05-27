context("bind_df_to_map")

test_that("state df gets bound to map",
{
  data(state.names, package="choroplethr", envir=environment())
  df = data.frame(region=state.names$abb, value=sample(100, 51))
  df.map = bind_df_to_map(df, "state")
  expect_equal(50763, nrow(df.map))
})

test_that("county df gets bound to map", {
  data(county.names, package="choroplethr", envir=environment())
  df = data.frame(region=county.names$county.fips.character, value=sample(100, nrow(county.names), replace=TRUE))
  df$region = as.character(df$region)
  df.map = bind_df_to_map(df, "county")
  expect_equal(96488, nrow(df.map))
})

test_that("zip df gets bound to map", {
  data(zipcode, package="zipcode", envir=environment())
  df = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=TRUE))
  df.map = bind_df_to_map(df, "zip")
  expect_equal(44309, nrow(df.map))
})