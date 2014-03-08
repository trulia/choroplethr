context("get_acs_df")

test_that("get_acs_df returns valid data for state population table with default parameters", {
  df = get_acs_df("B01003", "state")
  expect_equal(52, nrow(df))
  expect_true(all(state.name %in% df$region))
  expect_true(all(df$value > 0))
})

test_that("get_acs_df returns valid data for county population table with default parameters", {
  df = get_acs_df("B01003", "county")
  expect_true(nrow(df) > 3000 && nrow(df) < 4000)
  expect_true(all(county.fips$fips %in% df$region))
  expect_true(all(county.fips$fips %in% df$region))
  expect_true(all(df$value > 0))
})

test_that("get_acs_df returns valid data for zip population table with default parameters", {
  require(zipcode)
  data(zipcode)
  df = get_acs_df("B01003", "zip")
  expect_true(all(df$region %in% zipcode$zip))
  expect_true(all(df$value >= 0))
  expect_true(nrow(df) > 0)
})