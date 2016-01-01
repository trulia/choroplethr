.onAttach <- function(...) {
  if (!interactive() || stats::runif(1) > 0.1) return()
  
  tips <- c(
    "Need help? Try the Choroplethr Google Group: https://groups.google.com/forum/#!forum/choroplethr.",
    "Find out what's changed in Choroplethr: https://github.com/arilamstein/choroplethr/blob/master/NEWS.",
    "Use suppressPackageStartupMessages() to eliminate package startup messages.",
    "Stackoverflow is a great place to get help: http://stackoverflow.com/tags/r.",
    "Need help getting started? Try the free course 'Learn to Map Census Data in R': http://arilamstein.com/free-course/",
    "Want to take an in depth course on Choroplethr? Try 'Mapmaking in R with Choroplethr': http://courses.arilamstein.com/courses/mapmaking-r-choroplethr"
  )
  
  tip <- sample(tips, 1)
  packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
}