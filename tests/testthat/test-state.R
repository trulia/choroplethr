context("test state_choropleth")

test_that("default parameters returns ggplot", {
  data(df_pop_state)
  expect_is(state_choropleth(df_pop_state), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_state)
  expect_is(state_choropleth(df_pop_state, title="test title"), "ggplot")
})

test_that("setting legend returns ggplot", {
  data(df_pop_state)
  expect_is(state_choropleth(df_pop_state, legend="test legend"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_state)
  expect_is(state_choropleth(df_pop_state, num_colors=1), "ggplot")
})

test_that("west coast zoom returns ggplot", {
  data(df_pop_state)
  expect_is(state_choropleth(df_pop_state, zoom=c("california", "oregon", "washington"), num_colors=1), "ggplot")
})

test_that("error on invalid zoom", {
  data(df_pop_state)
  expect_error(state_choropleth(df_pop_state, zoom="asdf"))  
})

test_that("less than full states emits warning", {
  data(df_pop_state)
  df = df_pop_state[df_pop_state$region != "new york", ]
  expect_warning(state_choropleth(df))  
})

test_that("less than full states works", {
  data(df_pop_state)
  df = df_pop_state[df_pop_state$region != "new york", ]
  expect_is(
    suppressWarnings(state_choropleth(df)), 
    "ggplot")  
})

test_that("any duplicate regions trigger an error", {
  data(df_pop_state)
  df = rbind(df_pop_state, data.frame(region = "new york", value=1))
  expect_error(state_choropleth(df))
})

test_that("state reference map returns ggplot", {
  data(df_pop_state)
  data(continental_us_states)
  expect_is(state_choropleth(df_pop_state, 
                             zoom=continental_us_states,
                             reference_map=TRUE), "ggplot")
})
