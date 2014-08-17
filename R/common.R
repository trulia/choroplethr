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

get_state_fips_from_abb = function(state_abbs)
{
  stopifnot(state_abbs %in% state.abb)

  data(state.names, package="choroplethr", envir=environment())
  state.names[state.names$abb %in% state_abbs, "fips.character"]
}

# return a state or county map of the us, only showing the specified states
subset_map = function(lod, states=state.abb, countries=NULL)
{
  stopifnot(lod %in% c("state", "county", "world"))
  stopifnot(states %in% state.abb)
  stopifnot(!any(duplicated(states)))
  
  # get specified map
  if (lod == "state")
  {
    data(state.map, package="choroplethr", envir = environment())
    df = state.map
    
    # subset 
    states = normalize_state_names(states);
    df = df[df$region %in% states, ]
    
  } else if (lod == "county") {
    data(county.map, package="choroplethr", envir = environment())
    df = county.map
    
    # subset
    df = df[df$STATE %in% get_state_fips_from_abb(states), ]
  } else if (lod == "county") {
    df = df[df$region %in% countries, ]
  }
  
  df
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

stop_if_not_valid_choroplethr_object = function(x)
{
  stopifnot(is.data.frame(x))
  stopifnot(all(c("value","region") %in% colnames(x)) == TRUE)
  
}

#' Given two choropleth dfs, return a df that represents the percent change
#' 
#' @param a A data.frame representing a choropleth, with one column named region and one column named value
#' @param b A data.frame representing a choropleth, with one column named region and one column named value
#' 
#' @export
percent_change = function(a, b)
{
  stop_if_not_valid_choroplethr_object(a)
  stop_if_not_valid_choroplethr_object(b)
  
  stopifnot(is.numeric(a$value))
  stopifnot(is.numeric(b$value))
  
  x = merge(a, b, by="region")
  x$value = ((x$value.y - x$value.x) / x$value.x)*100
  
  x
}