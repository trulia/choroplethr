context("test num_colors")

test_that("state num_colors = 0 throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_colors=0))
})

test_that("state num_colors = 10 throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_colors=10))
})

test_that("county float num_colors throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_colors=1.5))
})

test_that("zip string num_colors throws exception", {
  data(df_pop_state, package="choroplethr")
  expect_error(state_choropleth(df_pop_state, num_colors="hello"))
})

test_that("country num_colors=1 returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, num_colors=1), "ggplot")
})

test_that("county num_colors=5 returns ggplot", {
  data(df_pop_state, package="choroplethr")
  expect_is(state_choropleth(df_pop_state, num_colors=1), "ggplot")
})
