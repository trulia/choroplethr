test_that("zip maps return ggplot with continuous and discrete scales", {
  data(df_pop_zip, package="choroplethr")
  
  m = ZipMap$new(df_pop_zip)
  expect_is(m$render(num_buckets=1), "ggplot")
  expect_is(m$render(num_buckets=2), "ggplot")
})

test_that("county maps return ggplot with continuous and discrete scales", {
  data(df_pop_county, package="choroplethr")
  
  c = CountyChoropleth$new(df_pop_county)
  expect_is(c$render(num_buckets=1), "ggplot")
  expect_is(c$render(num_buckets=2), "ggplot")
})

test_that("state maps return ggplot with continuous and discrete scales", {
  data(df_pop_state, package="choroplethr")
  
  c = StateChoropleth$new(df_pop_state)
  expect_is(c$render(num_buckets=1), "ggplot")
  expect_is(c$render(num_buckets=2), "ggplot")
})

test_that("country maps return ggplot with continuous and discrete scales", {
  data(country.names, package="choroplethr")
  
  df = data.frame(region=country.names$region, value=sample(1:nrow(country.names)))
  c = CountryChoropleth$new(df)
  expect_is(c$render(num_buckets=1), "ggplot")
  expect_is(c$render(num_buckets=2), "ggplot")
})