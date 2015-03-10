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

test_that("zip_choropleth_acs returns a ggplot2 with state_zoom set", {
  expect_is(
    zip_choropleth_acs("B19301", state_zoom="new york"),
    "ggplot")
})

test_that("zip_choropleth_acs returns a ggplot2 with county_zoom set", {
  nyc_fips = c(36005, 36047, 36061, 36081, 36085)
  expect_is(
    zip_choropleth_acs("B19301", county_zoom=nyc_fips),
    "ggplot")
})

test_that("zip_choropleth_acs returns a ggplot2 with msa_zoom set", {
  expect_is(
    zip_choropleth_acs("B19301", num_colors=1, msa_zoom="New York-Newark-Jersey City, NY-NJ-PA"),
    "ggplot")
})

test_that("zip_choropleth_acs returns a ggplot2 with zip_zoom set", {
  # compare Manhattan's Lower East Side and Upper East Side
  manhattan_les = c("10002", "10003", "10009")
  manhattan_ues = c("10021", "10028", "10044", "10128")
  expect_is(
    zip_choropleth_acs("B19301", num_colors=1, zip_zoom=c(manhattan_les, manhattan_ues)),
    "ggplot")
})