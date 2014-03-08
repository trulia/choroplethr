context("choroplethr_acs")

test_that("state level acs choropleth returns ggplots with discrete and continuous lods", {
  expect_is(choroplethr_acs("B00001", "state", num_buckets=1), "ggplot")
  expect_is(choroplethr_acs("B00001", "state", num_buckets=9), "ggplot")
})
                        
test_that("county level acs choropleth returns ggplots with discrete and continuous lods", {
  expect_is(choroplethr_acs("B00001", "county", num_buckets=1), "ggplot")
  expect_is(choroplethr_acs("B00001", "county", num_buckets=9), "ggplot")
})

test_that("zip level acs choropleth returns ggplots with discrete and continuous lods", {
  expect_is(choroplethr_acs("B00001", "zip", num_buckets=1), "ggplot")
  expect_is(choroplethr_acs("B00001", "zip", num_buckets=9), "ggplot")
})
