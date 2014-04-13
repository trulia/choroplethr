\name{format_levels}
\alias{format_levels}
\title{Make the output of cut2 a bit easier to read}
\usage{
format_levels(x, nsep = " to ")
}
\arguments{
  \item{x}{A factor with levels created via Hmisc::cut2.}

  \item{nsep}{A separator which you wish to use.  Defaults
  to " to ".}
}
\description{
Adds commas to numbers, removes unnecessary whitespace and
allows an arbitrary separator.
}
\examples{
data(choroplethr)

x = Hmisc::cut2(df_pop_state$value, g=3)
levels(x)
# [1] "[ 562803, 2851183)" "[2851183, 6353226)" "[6353226,37325068]"
levels(x) = sapply(levels(x), format_levels)
levels(x)
# [1] "[562,803 to 2,851,183)"    "[2,851,183 to 6,353,226)"  "[6,353,226 to 37,325,068]"
}
\seealso{
\url{http://stackoverflow.com/questions/22416612/how-can-i-get-cut2-to-use-commas/},
which this implementation is based on.
}

