# rendering a test state-level acs map at the continuous and discrete scales needs to return a valid ggplot object
expect_that(class(choroplethr_acs("B00001", "state", num_buckets=1)), matches(c("gg", "ggplot")))
expect_that(class(choroplethr_acs("B00001", "state", num_buckets=9)), matches(c("gg", "ggplot")))
                        
# rendering a test county-level acs map at the continuous and discrete scales needs to return a valid ggplot object
expect_that(class(choroplethr_acs("B00001", "county", num_buckets=1)), matches(c("gg", "ggplot")))
expect_that(class(choroplethr_acs("B00001", "county", num_buckets=9)), matches(c("gg", "ggplot")))

# do I need data(zipcode) here?
# rendering a test zip-level acs map at the continuous and discrete scales needs to return a valid ggplot object
expect_that(class(choroplethr_acs("B00001", "zip", num_buckets=1)), matches(c("gg", "ggplot")))
expect_that(class(choroplethr_acs("B00001", "zip", num_buckets=9)), matches(c("gg", "ggplot")))
