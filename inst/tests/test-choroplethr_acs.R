context("choroplethr_acs")

# these tests are valid but must be commented out for submissions to CRAN.
# because they require a valid census api key installed with the acs package, which
# CRAN does not have.
#test_that("state level acs choropleth returns ggplots with discrete and continuous lods", {
#  expect_equal(class(choroplethr_acs("B00001", "state", num_buckets=1)), c("gg", "ggplot"))
#  expect_equal(class(choroplethr_acs("B00001", "state", num_buckets=9)), c("gg", "ggplot"))
#})
                        
#test_that("county level acs choropleth returns ggplots with discrete and continuous lods", {
#  expect_equal(class(choroplethr_acs("B00001", "county", num_buckets=1)), c("gg", "ggplot"))
#  expect_equal(class(choroplethr_acs("B00001", "county", num_buckets=9)), c("gg", "ggplot"))
#})

#test_that("zip level acs choropleth returns ggplots with discrete and continuous lods", {
#  expect_equal(class(choroplethr_acs("B00001", "zip", num_buckets=1)), c("gg", "ggplot"))
#  expect_equal(class(choroplethr_acs("B00001", "zip", num_buckets=9)), c("gg", "ggplot"))
#})
