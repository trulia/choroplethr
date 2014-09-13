context("test zip_map")

test_that("default parameters returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, title="test title"), "ggplot")
})

test_that("setting legend_name returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, legend_name="test legend_name"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, num_buckets=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_map(df_pop_zip, zoom=c("california", "oregon", "washington")), "ggplot")
})

