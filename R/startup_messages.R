.onAttach <- function(...) {
  if (!interactive() || stats::runif(1) > 0.1) return()
  
  tips <- c(
    "Stay up to date on choroplethr by following the blog: http://arilamstein.com/blog",
    "Need help getting started? Try the free course 'Learn to Map Census Data in R': http://arilamstein.com/free-course/",
    "Technical question? Try stack overflow: http://stackoverflow.com/questions/tagged/r",
    "Want to take an in depth course on Choroplethr? Try 'Mapmaking in R with Choroplethr': http://courses.arilamstein.com/courses/mapmaking-r-choroplethr",
    "Use suppressPackageStartupMessages() to eliminate package startup messages."
  )
  
  tip <- sample(tips, 1)
  packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
}