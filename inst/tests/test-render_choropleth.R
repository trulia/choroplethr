context("render_choropleth")

test_that("state render_choropleth continuous returns a ggplot object", {
  df     = get_acs_df("B01003", "state") # population
  df.map = bind_df_to_map(df, "state")
  x      = render_choropleth(df.map, "state", "title", "scale name")
  expect_equal(class(x), c("gg", "ggplot"))
})

test_that("state render_choropleth discrete returns a ggplot object", {
  df     = get_acs_df("B01003", "state") # population
  df.map = bind_df_to_map(df, "state")
  df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
  x      = render_choropleth(df.map, "state", "title", "scale name")
  expect_equal(class(x), c("gg", "ggplot"))
})

test_that("county render_choropleth continuous returns a ggplot object", {
  df     = get_acs_df("B01003", "county") # population
  df.map = bind_df_to_map(df, "county")
  x      = render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")
  expect_equal(class(x), c("gg", "ggplot"))
})

test_that("county render_choropleth discrete returns a ggplot object", {
  df     = get_acs_df("B01003", "county") # population
  df.map = bind_df_to_map(df, "county")
  df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
  x      = render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")
  expect_equal(class(x), c("gg", "ggplot"))
})

test_that("zip render_choropleth continuous returns a ggplot object", {
  df       = get_acs_df("B01003", "zip") # population
  df.map   = bind_df_to_map(df, "zip")
  x = render_choropleth(df.map, "zip")
  expect_equal(class(x), c("gg", "ggplot"))
})

test_that("zip render_choropleth discrete returns a ggplot object", {
  df       = get_acs_df("B01003", "zip") # population
  df.map   = bind_df_to_map(df, "zip")
  df$value = cut2(df$value, g=3) # 3 equally-sized groups
  x = render_choropleth(df.map, "zip")
  expect_equal(class(x), c("gg", "ggplot"))
})