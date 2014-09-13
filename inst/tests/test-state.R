context("test state_choropleth")

test_that("default parameters returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, title="test title"), "ggplot")
})

test_that("setting legend_name returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, legend_name="test legend_name"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, num_buckets=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, zoom=c("california", "oregon", "washington")), "ggplot")
})

