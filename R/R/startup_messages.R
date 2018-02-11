.onAttach <- function(...) {
  if (!interactive()) return()
  
  tips <- c(
    "View the Choroplethr documentation here: www.AriLamstein.com/open-source",
    "Choroplethr has a free course: www.CensusMappingCourse.com"
  )
  
  tip <- sample(tips, 1)
  packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
}