context("test country_choropleth")

test_that("default parameters returns ggplot", {
  data(df_pop_country, package="choroplethr")
  expect_is(country_choropleth(df_pop_country), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_country, package="choroplethr")
  expect_is(country_choropleth(df_pop_country, title="test title"), "ggplot")
})

test_that("setting legend_name returns ggplot", {
  data(df_pop_country, package="choroplethr")
  expect_is(country_choropleth(df_pop_country, legend_name="test legend_name"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_country, package="choroplethr")
  expect_is(country_choropleth(df_pop_country, num_buckets=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_country, package="choroplethr")
  expect_is(country_choropleth(df_pop_country, num_buckets=2, zoom=c("united states of america", "mexico", "canada")), "ggplot")
})

test_that("error on invalid zoom", {
  data(df_pop_country, package="choroplethr")
  expect_error(country_choropleth(df_pop_country, zoom="asdf"))  
})

