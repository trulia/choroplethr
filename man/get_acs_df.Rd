\name{get_acs_df}
\alias{get_acs_df}
\title{Returns a data.frame representing American Community Survey estimates.}
\usage{
get_acs_df(tableId, lod, endyear = 2012, span = 5, column_idx = -1)
}
\arguments{
  \item{tableId}{The id of an ACS table.}

  \item{lod}{The level of geographic detail for the
  data.frame.  Must be one of "state", "county" or "zip".}

  \item{endyear}{The end year of the survey.  Defaults to
  2012.}

  \item{span}{The span of the survey.  Defaults to 5.}

  \item{column_idx}{An optional column index to specify.}
}
\value{
A data.frame.
}
\description{
Requires the acs package to be installed, and a Census API
Key to be set with the acs's api.key.install function.
Census API keys can be obtained at
http://www.census.gov/developers/tos/key_request.html.
}
\examples{
\dontrun{
library(Hmisc) # for cut2
# States with greater than 1M residents
df     = get_acs_df("B01003", "state") # population
df.map = bind_df_to_map(df, "state")
df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
render_choropleth(df.map, "state", "States with a population over 1M", "Population")

# Counties with greater than or greater than 1M residents
df     = get_acs_df("B01003", "county") # population
df.map = bind_df_to_map(df, "county")
df.map$value = cut2(df.map$value, cuts=c(0,1000000,Inf))
render_choropleth(df.map, "county", "Counties with a population over 1M", "Population")

# ZIP codes in California where median age is between 20 and 30
df       = get_acs_df("B01002", "zip") # median age
df       = df[df$value >= 20 & df$value <= 30, ]
df$value = cut2(df$value, g=3) # 3 equally-sized groups
df.map   = bind_df_to_map(df, "zip")
render_choropleth(df.map,
                 "zip",
                 title = "CA Zip Codes by Age",
                 scaleName = "Median Age",
                 states = "CA")
}
}
\seealso{
http://factfinder2.census.gov/faces/help/jsf/pages/metadata.xhtml?lang=en&type=survey&id=survey.en.ACS_ACS,
which lists all ACS Surveys.
}

