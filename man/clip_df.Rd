\name{clip_df}
\alias{clip_df}
\title{Clip a data.frame to a map}
\usage{
clip_df(df, lod, states = state.abb)
}
\arguments{
  \item{df}{A data.frame with a column named "region".  If
  lod is "state" then region must contain state names (e.g.
  "California" or "CA").  If lod is "county" then region
  must contain county FIPS codes.  if lod is "zip" then
  region must contain 5 digit ZIP codes.}

  \item{lod}{A string representing the level of detail of
  the map you want.  Must be one of "state", "county" or
  "zip".}

  \item{states}{A list of states to subset. Must be a
  subset of state.abb.}
}
\value{
A data.frame.
}
\description{
Given a data.frame and a lod, remove elements from the
data.frame which will not appear in the map. This is useful
if you want to do a statistical analysis on the data.frame
based on how it will appear in the map.  For example,
choroplethr currently does not display Alaska or Hawaii. So
if you want to report on the median value in a data set,
and have the map reflect your analysis, you should first
call this function on the data.frame.  It is the first
function call in choroplethr().
}
\examples{
data(choroplethr)
library(Hmisc) # for cut2

data(choroplethr)
nrow(df_pop_state) # 52
new_df = clip_df(df_pop_state, "state")
nrow(new_df) # 48

nrow(df_pop_county) # 3221
new_df = clip_df(df_pop_county, "county")
nrow(new_df) # 3074

nrow(df_pop_zip) # 33120
new_df = clip_df(df_pop_zip, "zip")
nrow(new_df) # 32936
}

