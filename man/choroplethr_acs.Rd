\name{choroplethr_acs}
\alias{choroplethr_acs}
\title{Create a choropleth from ACS data.}
\usage{
choroplethr_acs(tableId, lod, num_buckets = 9, showLabels = T)
}
\arguments{
  \item{tableId}{The id of an ACS table}

  \item{lod}{A string indicating the level of detail of the
  map.  Must be "state", "county" or "zip".}

  \item{num_buckets}{The number of equally sized buckets to
  places the values in.  A value of 1 will use a continuous
  scale, and a value in [2, 9] will use that many buckets.
  For example, 2 will show values above or below the
  median, and 9 will show the maximum resolution.  Defaults
  to 9.}

  \item{showLabels}{For state choropleths, whether or not
  to show state abbreviations on the map. Defaults to T.}
}
\value{
A choropleth
}
\description{
Creates a choropleth using the US Census' American
Community Survey (ACS) data. Requires the acs package to be
installed, and a Census API Key to be set with the acs's
api.key.install function.
}
\examples{
# total population, state level
choroplethr_acs("B00001", "state", 1);

# total population, county level, above and below median
choroplethr_acs("B00001", "county", 2);

# per capita income, zip code, continuous scale
choroplethr_acs("B19301", "zip");

# median age by sex
choroplethr_acs("B01002", "state")
}
\seealso{
\code{\link{choroplethr}} which this function wraps

\code{\link{api.key.install}} which sets an Census API key
for the acs library

http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_11_5YR#,
which contains a list of tables from the 2011 5 year ACS.
}
\keyword{acs}
\keyword{choropleth,}

