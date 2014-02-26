\name{bind_df_to_map}
\alias{bind_df_to_map}
\title{Bind a data.frame to a map}
\usage{
bind_df_to_map(df, lod, states = state.abb)
}
\arguments{
  \item{df}{A data.frame with one column named "region" and
  one column named "value".}

  \item{lod}{A string representing the level of detail of
  the map you want.  Must be one of "state", "county" or
  "zip".}

  \item{states}{a vector of postal codes representing US
  states.  Defaults to state.abb.}
}
\value{
A data.frame.
}
\description{
Given a data.frame which contains (region, value) pairs,
bind it to either a state, county or ZIP code map.  The
result can then be rendered by calling render_choropleth.
}
\seealso{
\code{\link{render_choropleth}}.
}

