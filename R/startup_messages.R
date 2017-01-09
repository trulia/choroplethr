.onAttach <- function(...) {
  if (!interactive()) return()
  
  packageStartupMessage("Choroplethr has a free course: www.CensusMappingCourse.com")
}