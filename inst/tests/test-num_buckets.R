context("test buckets")

test_that("state buckets = 0 throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, buckets=0))
})

test_that("state buckets = 10 throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, buckets=10))
})

test_that("county float buckets throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, buckets=1.5))
})

test_that("zip string buckets throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, buckets="hello"))
})

test_that("country buckets=1 returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, buckets=1), "ggplot")
})

test_that("county buckets=5 returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, buckets=1), "ggplot")
})
