\name{choroplethr}
\alias{choroplethr}
\title{Create a choropleth}
\usage{
choroplethr(df, lod, num_buckets = 9, title = "", roundLabel = T,
  scaleName = "", showLabels = T)
}
\arguments{
  \item{df}{A data.frame with a column named "region" and a
  column named "value"}

  \item{lod}{A string indicating the level of detail of the
  map.  Must be "state", "county" or "zip".}

  \item{num_buckets}{The number of equally sized buckets to
  places the values in.  A value of 1 will use a continuous
  scale, and a value in [2, 9] will use that many buckets.
  For example, 2 will show values above or below the
  median, and 9 will show the maximum resolution.  Defaults
  to 9.}

  \item{title}{A title for the map.  Defaults to "".}

  \item{roundLabel}{Whether to round values in the label of
  the map.  Default to T.}

  \item{scaleName}{An optional label for the legend.
  Defaults to "".}

  \item{showLabels}{For state choropleths, whether or not
  to show state abbreviations on the map. Defaults to T.}
}
\value{
A choropleth
}
\description{
Creates a choropleth from a specified data.frame and level
of detail.
}
\examples{
# a state choropleth
df = data.frame(region=state.abb, value=sample(100, 50))
choroplethr(df, lod="state")

# a county choropleth
df = data.frame(region=county.fips$fips, value=sample(100, nrow(county.fips), replace=T))
choroplethr(df, "county", 2)

# a zip choropleth
data(zipcode)
df = data.frame(region=zipcode$zi, value = sample(100, nrow(zipcode), replace=T))
choroplethr(df, "zip", 9)
}
\seealso{
\code{\link{choroplethr_acs}} which generates choropleths
from Census tables.
}
\keyword{choropleth}

