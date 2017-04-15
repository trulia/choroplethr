context("test county_choropleth")

test_that("default parameters returns ggplot", {
  data(df_pop_county)
  expect_is(county_choropleth(df_pop_county), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_county)
  expect_is(county_choropleth(df_pop_county, title="test title"), "ggplot")
})

test_that("setting legend returns ggplot", {
  data(df_pop_county)
  expect_is(county_choropleth(df_pop_county, legend="test legend"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_county)
  expect_is(county_choropleth(df_pop_county, num_colors=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_county)
  expect_is(county_choropleth(df_pop_county, state_zoom=c("california", "oregon", "washington")), "ggplot")
})

test_that("nyc county zoom returns ggplot", {
  data(df_pop_county)
  nyc_county_fips = c(36005, 36047, 36061, 36081, 36085)
  county_choropleth(df_pop_county, num_colors=1, county_zoom=nyc_county_fips)
})

test_that("error on invalid zoom", {
  data(df_pop_county)
  expect_error(county_choropleth(df_pop_county, state_zoom="asdf"))  
})

test_that("less than full counties emits warning", {
  data(df_pop_county)
  df = df_pop_county[df_pop_county$region <= 10000, ]
  expect_warning(county_choropleth(df))  
})

test_that("less than full states works", {
  data(df_pop_county)
  df = df_pop_county[df_pop_county$region <= 10000, ]
  expect_is(suppressWarnings(county_choropleth(df)), "ggplot")  
})

test_that("county reference map returns ggplot", {
  data(df_pop_county)
  data(continental_us_states)
  expect_is(county_choropleth(df_pop_county, 
                              state_zoom=continental_us_states,
                              reference_map=TRUE), "ggplot")
})
