context("test num_buckets")

test_that("state num_buckets = 0 throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_buckets=0))
})

test_that("state num_buckets = 10 throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_buckets=10))
})

test_that("county float num_buckets throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_buckets=1.5))
})

test_that("zip string num_buckets throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_buckets="hello"))
})

test_that("country num_buckets=1 returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, num_buckets=1), "ggplot")
})

test_that("county num_buckets=5 returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, num_buckets=1), "ggplot")
})
