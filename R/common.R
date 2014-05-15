normalize_state_names = function(state_names)
{
  if (is.factor(state_names))
  {
    state_names = as.character(state_names)
  }
  
  if (is.character(state_names))
  {
    if (all(nchar(state_names) == 2))
    {
      state_names = toupper(state_names) # "Ny" -> "NY"
      state_names = tolower(state.name[match(state_names, state.abb)])
    } else {      
      # otherwise assume "New York", "new york", etc.
      state_names = tolower(state_names);
    }
  }
  
  # TODO: handle FIPS codes for states
  # fips codes are integers (at least in state.fips$fips), which might be a bug since technically
  # they should have leading 0's.
  # TODO: emit warnings for states that are not present
  
  state_names;
}

# return a state or county map of the us, only showing the specified states
#' @importFrom ggplot2 map_data
subset_map = function(lod, states)
{
  stopifnot(lod %in% c("state", "county"))
  stopifnot(states %in% state.abb)
  stopifnot(!any(duplicated(states)))
  
  # get specified map
  if (lod == "state")
  {
    df = map_data("state")
  } else if (lod == "county") {
    df = map_data("county")
  }
  
  # subset 
  states = normalize_state_names(states);
  df[df$region %in% states, ]
}

#' Create a simple ggplot2 theme for rendering choropleths
#' 
#' Removes axes, margins and sets the background to white.
#' 
#' @importFrom grid unit
#' @export
#' @references This code, with minor modifications comes from section 13.19 
# "Making a Map with a Clean Background" of "R Graphics Cookbook" by Winston Chang.  
# Reused with permission. 
theme_clean = function()
{
  theme(
    axis.title        = element_blank(),
    axis.text         = element_blank(),
    panel.background  = element_blank(),
    panel.grid        = element_blank(),
    axis.ticks.length = unit(0, "cm"),
    axis.ticks.margin = unit(0, "cm"),
    panel.margin      = unit(0, "lines"),
    plot.margin       = unit(c(0, 0, 0, 0), "lines"),
    complete          = TRUE
  )
}

# like theme clean, but also remove the legend
theme_inset = function()
{
  theme(
    legend.position   = "none",
    axis.title        = element_blank(),
    axis.text         = element_blank(),
    panel.background  = element_blank(),
    panel.grid        = element_blank(),
    axis.ticks.length = unit(0, "cm"),
    axis.ticks.margin = unit(0, "cm"),
    panel.margin      = unit(0, "lines"),
    plot.margin       = unit(c(0, 0, 0, 0), "lines"),
    complete          = TRUE
  )
}
#' Make the output of cut2 a bit easier to read
#' 
#' Adds commas to numbers, removes unnecessary whitespace and allows an arbitrary separator.
#' 
#' @param x A factor with levels created via Hmisc::cut2.
#' @param nsep A separator which you wish to use.  Defaults to " to ".
#' 
#' @export
#' @examples
#' data(choroplethr)
#'
#' x = Hmisc::cut2(df_pop_state$value, g=3)
#' levels(x)
#' # [1] "[ 562803, 2851183)" "[2851183, 6353226)" "[6353226,37325068]"
#' levels(x) = sapply(levels(x), format_levels)
#' levels(x)
#' # [1] "[562,803 to 2,851,183)"    "[2,851,183 to 6,353,226)"  "[6,353,226 to 37,325,068]"
#'
#' @seealso \url{http://stackoverflow.com/questions/22416612/how-can-i-get-cut2-to-use-commas/}, which this implementation is based on.
#' @importFrom stringr str_extract_all
format_levels = function(x, nsep=" to ") 
{
  n = str_extract_all(x, "[-+]?[0-9]*\\.?[0-9]+")[[1]]  # extract numbers
  v = format(as.numeric(n), big.mark=",", trim=TRUE) # change format
  x = as.character(x)
  
  # preserve starting [ or ( if appropriate
  prefix = ""
  if (substring(x, 1, 1) %in% c("[", "("))
  {
    prefix = substring(x, 1, 1)
  }
  
  # preserve ending ] or ) if appropriate
  suffix = ""
  if (substring(x, nchar(x), nchar(x)) %in% c("]", ")"))
  {
    suffix = substring(x, nchar(x), nchar(x))
  }
  
  # recombine
  paste0(prefix, paste(v,collapse=nsep), suffix)
}

# for us, discretizing values means 
# 1. breaking the values into num_buckets equal intervals
# 2. formatting the intervals e.g. with commas
#' @importFrom Hmisc cut2
discretize_values = function(values, num_buckets)
{
  # if cut2 uses scientific notation,  our attempt to put in commas will fail
  scipen_orig = getOption("scipen")
  options(scipen=999)
  ret = cut2(values, g = num_buckets)
  options(scipen=scipen_orig)
  
  levels(ret) = sapply(levels(ret), format_levels)
  ret
}

discretize_df = function(df, num_buckets)
{
  stopifnot(is.data.frame(df))
  stopifnot("value" %in% colnames(df))
  stopifnot(is.numeric(num_buckets) && num_buckets > 0 && num_buckets < 10)
  
  if (is.numeric(df$value) && num_buckets > 1) {
    df$value = discretize_values(df$value, num_buckets)
  }
  
  df
}

