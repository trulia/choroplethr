context("test the vaious _acs functions")

# "B19301" is table for median income

test_that("state_choropleth_acs returns a ggplot2 with default parameters", {
  expect_is(state_choropleth_acs("B19301"), "ggplot") 
})

test_that("state_choropleth_acs returns a ggplot2 with parameters set", {
  expect_is(state_choropleth_acs("B19301", num_colors=1, zoom=c("new york", "new jersey", "connecticut")), "ggplot") 
})

test_that("county_choropleth_acs returns a ggplot2 with default parameters", {
  expect_is(county_choropleth_acs("B19301"), "ggplot") 
})

test_that("county_choropleth_acs returns a ggplot2 with parameters set", {
  expect_is(
    county_choropleth_acs("B19301", num_colors=1, state_zoom=c("new york", "new jersey", "connecticut")), 
    "ggplot")
})

test_that("county_choropleth_acs returns a ggplot2 with state_zoom set", {
  expect_is(
    county_choropleth_acs("B19301", num_colors=1, state_zoom=c("new york", "new jersey", "connecticut")), 
    "ggplot")
})

test_that("county_choropleth_acs returns a ggplot2 with county_zoom set", {
  nyc_county_fips = c(36005, 36047, 36061, 36081, 36085)
  expect_is(
    county_choropleth_acs("B19301", num_colors=1, county_zoom=nyc_county_fips), 
    "ggplot")
})