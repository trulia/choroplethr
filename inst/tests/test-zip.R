context("test zip_choropleth")

test_that("state_zoom returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_choropleth(df_pop_zip, state_zoom=c("new york")), "ggplot")
})

test_that("default parameters returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_choropleth(df_pop_zip), state_zoom=c("new york")), "ggplot")
})

test_that("setting title returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_choropleth(df_pop_zip, state_zoom=c("new york")), title="test title"), "ggplot")
})

test_that("setting legend returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_choropleth(df_pop_zip, state_zoom=c("new york")), legend="test legend"), "ggplot")
})

test_that("continuous scale returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_choropleth(df_pop_zip, state_zoom=c("new york")), num_colors=1), "ggplot")
})

test_that("county_zoom returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  nyc_fips = c(36005, 36047, 36061, 36081, 36085)
  expect_is(zip_choropleth(df_pop_zip,
                           county_zoom=nyc_fips,
                           title="2012 New York City Zip Population Estimates",
                           legend="Population"), "ggplot")
})

test_that("zip_zoom returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  manhattan_les = c("10002", "10003", "10009")
  manhattan_ues = c("10021", "10028", "10044", "10128")
  zip_choropleth(df_pop_zip,
                 zip_zoom=c(manhattan_les, manhattan_ues),
                 title="2012 Lower and Upper East Side Zip Population Estimates",
                 legend="Population")
})

test_that("msa_zoom returns ggplot", {
  data(df_pop_zip, package="choroplethr")
  expect_is(zip_choropleth(df_pop_zip,
                 msa_zoom="New York-Newark-Jersey City, NY-NJ-PA",
                 title="2012 NY-Newark-Jersey City MSA\nZip Population Estimates",
                 legend="Population"), "ggplot")
})

