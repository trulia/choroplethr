context("render_choropleth")

test_that("state render_choropleth continuous returns a ggplot object", {
  df = data.frame(region=state.abb, value=sample(100, 50))  
  df.map = bind_df_to_map(df, "state")
  choropleth = render_choropleth(df.map, "state", "title", "scale name")
  expect_is(choropleth, "ggplot")
})

test_that("state render_choropleth discrete returns a ggplot object", {
  df = data.frame(region=state.abb, value=sample(100, 50))
  df.map = bind_df_to_map(df, "state")
  df.map$value = cut2(df.map$value, cuts=c(0,25, 50, 100))
  choropleth = render_choropleth(df.map, "state", "title", "scale name")
  expect_is(choropleth, "ggplot")
})

test_that("county render_choropleth continuous returns a ggplot object", {
  df         = data.frame(region=county.names$county.fips.numeric, value=sample(100, length(county.names$county.fips.character), replace=T))
  df.map     = bind_df_to_map(df, "county", warn_na=FALSE)
  choropleth = render_choropleth(df.map, "county", "test continuous counties", "scale name")
  expect_is(choropleth, "ggplot")
})

test_that("county render_choropleth discrete returns a ggplot object", {
  df           = data.frame(region=county.names$county.fips.numeric, value=sample(100, length(county.names$county.fips.character), replace=T))
  df.map       = bind_df_to_map(df, "county", warn_na=FALSE)
  df.map$value = cut2(df.map$value, cuts=c(0,50,Inf))
  choropleth   = render_choropleth(df.map, "county", "test discrete counties", "scale name")
  expect_is(choropleth, "ggplot")
})

test_that("zip render_choropleth continuous returns a ggplot object", {
  data(zipcode, package="zipcode", envir=environment())
  df       = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=TRUE))
  df.map   = bind_df_to_map(df, "zip")
  expect_is(render_choropleth(df.map, "zip"), "ggplot")
})

test_that("zip render_choropleth discrete returns a ggplot object", {
  data(zipcode, package="zipcode", envir=environment())
  df       = data.frame(region=zipcode$zip, value = sample(100, nrow(zipcode), replace=TRUE))
  df.map   = bind_df_to_map(df, "zip")
  df$value = cut2(df$value, g=3) # 3 equally-sized groups
  expect_is(render_choropleth(df.map, "zip"), "ggplot")
})
