context("test state_choropleth")

test_that("default parameters returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, title="test title"), "ggplot")
})

test_that("setting legend returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, legend="test legend"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, num_buckets=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, zoom=c("california", "oregon", "washington")), "ggplot")
})

test_that("error on invalid zoom", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, zoom="asdf"))  
})
