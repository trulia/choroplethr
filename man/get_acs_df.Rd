\name{get_acs_df}
\alias{get_acs_df}
\title{Returns a data.frame representing American Community Survey estimates.}
\usage{
get_acs_df(tableId, lod, endyear = 2012, span = 5)
}
\arguments{
  \item{tableId}{The id of an ACS table.}

  \item{lod}{The level of geographic detail for the
  data.frame.  Must be one of "state", "county" or "zip".}

  \item{endyear}{The end year of the survey.  Defaults to
  2012.}

  \item{span}{The span of the survey.  Defaults to 5.}
}
\value{
A data.frame
}
\description{
Returns a data.frame representing American Community Survey
estimates.
}
\seealso{
http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS,
which lists all ACS Surveys.
}

