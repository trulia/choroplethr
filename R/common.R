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

#' @importFrom grid unit
# this code, with minor modifications comes from section 13.19 
# "Making a Map with a Clean Background" of "R Graphics Cookbook" by Winston Chang.  
# Reused with permission. Create a theme with many of the background elements removed
theme_clean = function(base_size = 12)
{
  theme_grey(base_size);
  theme(
    axis.title        = element_blank(),
    axis.text         = element_blank(),
#     panel.background  = element_blank(),
    panel.grid        = element_blank(),
    axis.ticks.length = unit(0, "cm"),
    axis.ticks.margin = unit(0, "cm"),
    panel.margin      = unit(0, "lines"),
    plot.margin       = unit(c(0, 0, 0, 0), "lines"),
    complete = TRUE
  )
}

discretize_values = function(values, num_buckets)
{
  cut2(values, g=num_buckets)
}
