#' @importFrom R6 R6Class
#' @importFrom scales comma
Choropleth = R6Class("Choropleth", 
  public = list(
    title        = "",    # title for map
    scale_name   = "",    # title for scale
    warn         = FALSE, # warn user on clipped or missing values                      
    ggplot_scale = NULL,  # override default scale
    
    # a choropleth map is defined by these 3 variables
    # a data.frame from a user that columns called "region" and "value"
    # a data.frame of a map
    # a data.frame that lists names, as they appear in map.df
    initialize = function(map.df, map.names, user.df)
    {
      # all input, regardless of map, is just a bunch of (region, value) pairs
      stopifnot(is.data.frame(user.df))
      stopifnot(c("region", "value") %in% colnames(user.df))
      self$user.df = user.df
      self$user.df = self$user.df[, c("region", "value")]
      
      self$map.df    = map.df
      self$map.names = map.names
    },

    # explain what num_buckets means
    render = function(num_buckets=7) 
    {
      stopifnot(num_buckets > 1 && num_buckets < 10)
      self$num_buckets = num_buckets
      
      self$prepare_map()
      
      ggplot(self$choropleth.df, aes(long, lat, group = group)) +
        geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
        get_scale() +
        theme_clean()
    },

    # the key objects for this class
    user.df       = NULL, # input from user
    map.df        = NULL, # geometry of the map
    choropleth.df = NULL, # result of binding user data with our map data
    map.names     = NULL, # a helper object that lists various naming conventions for the regions
    
    num_buckets   = 7,      # number of equally-sized buckets for scale. use continuous scale if 1
    regions       = NULL,   # if not NULL, only render the regions listed
    
    # If input comes in as "NY" but map uses "new york", rename the input to match the map
    rename_regions = function()
    {
      stop("Base classes should override this function")
    },    
    
    # perhaps user only want to view, e.g., states on the west coast
    clip = function() {
      stop("Base classes should override")
    },
    
    # for us, discretizing values means 
    # 1. breaking the values into num_buckets equal intervals
    # 2. formatting the intervals e.g. with commas
    #' @importFrom Hmisc cut2    
    discretize = function() 
    {
      if (is.numeric(self$user.df$value) && self$num_buckets > 1) {
        
        # if cut2 uses scientific notation,  our attempt to put in commas will fail
        scipen_orig = getOption("scipen")
        options(scipen=999)
        self$user.df$value = cut2(self$user.df$value, g = self$num_buckets)
        options(scipen=scipen_orig)
        
        levels(self$user.df$value) = sapply(levels(self$user.df$value), format_levels)
      }
    },
    
    bind = function() {
      stop("Base classes should override")
    },
    
    prepare_map = function()
    {
      # before a map can really be rendered, you need to ...
      self$rename_regions() # rename input regions (e.g. "NY") to match regions in map (e.g. "new york")
      self$clip() # clip the input - e.g. remove value for Washington DC on a 50 state map
      self$discretize() # discretize the input. normally people don't want a continuous scale
      self$bind() # bind the input values to the map values
    },
    
    get_scale = function()
    {
      if (!is.null(ggplot_scale)) 
      {
        ggplot_scale
      } else if (self$num_buckets == 1) {
        scale_fill_continuous(self$scale_name, labels=comma, na.value="black", limits=c(min, max))
      } else {
        scale_fill_brewer(self$scale_name, drop=FALSE, labels=comma, na.value="black")        
      }
    },
    
    #' Removes axes, margins and sets the background to white.
    #' This code, with minor modifications, comes from section 13.19 
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
    },
    
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
    })
)
