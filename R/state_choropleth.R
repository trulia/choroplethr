#' @export
#' @importFrom dplyr left_join
StateChoropleth = R6Class("StateChoropleth",
  inherit = Choropleth,
  
  public = list(
    # initialize with us state map
    initialize = function(user.df)
    {
      data(state.map)
      data(state.names)
      super$initialize(state.map, state.names, user.df)
    }),
  
  private = list(
    
    # There are several ways that people might call a state.  E.g. "New York", "NY", etc.
    # Convert common namings to "new york", which is what the map.df uses
    rename_regions = function()
    {
      # TODO: handle FIPS codes for states
      # fips codes are integers (at least in state.fips$fips), which might be a bug since technically
      # they should have leading 0's.
      # TODO: emit warnings for states that are not present
      if (is.factor(private$user.df$region))
      {
        private$user.df$region = as.character(private$user.df$region)
      }
      
      if (is.character(private$user.df$region))
      {
        if (all(nchar(private$user.df$region) == 2))
        {
          private$user.df$region = toupper(private$user.df$region) # "Ny" -> "NY"
          private$user.df$region = tolower(state.name[match(private$user.df$region, state.abb)])
        } else {      
          # otherwise assume "New York", "new york", etc.
          private$user.df$region = tolower(private$user.df$region);
        }
      }
    },
    
    clip = function()
    {
      choroplethr.state.names = tolower(state.name)
      private$user.df = private$user.df[private$user.df$region %in% choroplethr.state.names, ]
    },
    
    bind = function()
    {      
      private$choropleth.df = left_join(private$map.df, private$user.df, by="region")
      missing_states = unique(private$choropleth.df[is.na(private$choropleth.df$value), ]$region)
      # while the map contains Washington, DC, choroplethr does not support it because it 
      # is not in state.abb and is not technically a state.
      missing_states = setdiff(missing_states, "district of columbia")
      if (self$warn && length(missing_states) > 0)
      {
        missing_states = paste(missing_states, collapse = ", ");
        warning_string = paste("The following regions were missing and are being set to NA:", missing_states);
        print(warning_string);
      }
      
      private$choropleth.df = private$choropleth.df[order(private$choropleth.df$order), ];
    })
)