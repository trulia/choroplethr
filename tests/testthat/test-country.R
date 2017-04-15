context("test country_choropleth")

# to avoid spurious warnings, use this df. df_pop_country is missing a few regions
get_test_df = function()
{
  data(country.regions, package="choroplethrMaps")
  n   = nrow(country.regions)
  ret = data.frame(region=as.character(country.regions$region), value=sample(n))
  ret$region = as.character(ret$region)
  ret
}

test_that("default parameters returns ggplot", {
  df = get_test_df()
  expect_is(country_choropleth(df), "ggplot")
})

test_that("setting title returns ggplot", {
  df = get_test_df()
  expect_is(country_choropleth(df, title="test title"), "ggplot")
})

test_that("setting legend returns ggplot", {
  df = get_test_df()
  expect_is(country_choropleth(df, legend="test legend"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  df = get_test_df()
  expect_is(country_choropleth(df, num_colors=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  df = get_test_df()
  expect_is(country_choropleth(df, num_colors=2, zoom=c("united states of america", "mexico", "canada")), "ggplot")
})

test_that("error on invalid zoom", {
  df = get_test_df()
  expect_error(country_choropleth(df, zoom="asdf"))  
})

test_that("less than full countries emits warning", {
  df = get_test_df()
  df = df[df$region != "angola", ]
  expect_warning(country_choropleth(df))  
})

test_that("less than full countries works", {
  df = get_test_df()
  df = df[df$region != "angola", ]
  expect_is(suppressWarnings(country_choropleth(df)), "ggplot")
})

test_that("regions not on map emit warning", {
  df = get_test_df()
  df = rbind(df, data.frame(region="asdf", value=1))
  expect_warning(country_choropleth(df))  
})

test_that("duplicate regions emit error", {
  df = get_test_df()
  df = rbind(df, data.frame(region="angola", value=1))
  expect_error(country_choropleth(df))  
})

