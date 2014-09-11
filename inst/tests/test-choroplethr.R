context("choroplethr")

# turn warnings off when testing choroplethr(), beucase that function is deprecated
# and emits a warning to that effect every time it's called!
options(warn=-1)

test_that("state level choropleths return ggplots with discrete and continuous lods", {
  data(df_pop_state, package="choroplethr")
  expect_is(choroplethr(df_pop_state, lod="state", num_buckets=1), "ggplot")
  expect_is(choroplethr(df_pop_state, lod="state", num_buckets=9), "ggplot")
})

test_that("county level choropleths return ggplots at discrete and continuous lods", {
  data(df_pop_county, package="choroplethr")
  expect_is(choroplethr(df_pop_county, lod="county", num_buckets=1, warn_na=FALSE), "ggplot")
  expect_is(choroplethr(df_pop_county, lod="county", num_buckets=9, warn_na=FALSE), "ggplot")
})

test_that("zip level choropleths return ggplots at discrete and continuous lods", {  
  data(df_pop_zip, package="choroplethr")
  expect_is(choroplethr(df_pop_zip, lod="zip", num_buckets=1), "ggplot")
  expect_is(choroplethr(df_pop_zip, lod="zip", num_buckets=9), "ggplot")
})

test_that("country level choropleths return ggplots at discrete and continuous lods", {  
  data(df_pop_country, package="choroplethr")
  expect_is(choroplethr(df_pop_country, lod="world", num_buckets=1), "ggplot")
  expect_is(choroplethr(df_pop_country, lod="world", num_buckets=9), "ggplot")
})

options(warn=0)
