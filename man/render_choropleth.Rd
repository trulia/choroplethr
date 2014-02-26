\name{render_choropleth}
\alias{render_choropleth}
\title{Render a choropleth}
\usage{
render_choropleth(choropleth.df, lod, title = "", scaleName = "",
  showLabels = TRUE, states = state.abb)
}
\arguments{
  \item{choropleth.df}{A data.frame with one column named
  "region" and one column named "value".  The variable is
  normally the output of bind_df_to_map.}

  \item{lod}{A string representing the level of detail of
  the map you want.  Must be one of "state", "county" or
  "zip".}

  \item{title}{The title of the image.  Defaults to "".}

  \item{scaleName}{the name of the scale/legend.  Default
  to "".}

  \item{showLabels}{for State maps, whether or not to show
  labels of the states.}

  \item{states}{a vector of postal codes representing US
  states.  Defaults to state.abb.}
}
\value{
A data.frame.
}
\description{
Given a data.frame which contains map data and value data,
render it as a map using ggplot2.
}
\seealso{
\code{\link{bind_df_to_map}}
}

