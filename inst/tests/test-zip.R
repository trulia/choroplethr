context("test zip_map")

test_that("default parameters returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, title="test title"), "ggplot")
})

test_that("setting legend returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, legend="test legend"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, buckets=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, zoom=c("california", "oregon", "washington")), "ggplot")
})

test_that("error on invalid zoom", {
  data(df_pop_zip, package="choroplethr")
  expect_error(zip_map(df_pop_zip, zoom="asdf"))  
})


