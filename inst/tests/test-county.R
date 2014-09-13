context("test county_choropleth")

test_that("default parameters returns ggplot", {
  data(df_pop_county, package="choroplethr")
  expect_is(county_choropleth(df_pop_county), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_county, package="choroplethr")
  expect_is(county_choropleth(df_pop_county, title="test title"), "ggplot")
})

test_that("setting legend_name returns ggplot", {
  data(df_pop_county, package="choroplethr")
  expect_is(county_choropleth(df_pop_county, legend_name="test legend_name"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_county, package="choroplethr")
  expect_is(county_choropleth(df_pop_county, num_buckets=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_county, package="choroplethr")
  expect_is(county_choropleth(df_pop_county, zoom=c("california", "oregon", "washington")), "ggplot")
})

