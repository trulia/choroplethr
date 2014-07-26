Choropleth <- R6Class("Choropleth", 
  public = list(
    # every choropleth map in this package needs to have these vars, and do this input validation
    initialize = function(df,                    # input from user
                          title        = "",     # title for map
                          scale_name   = "",     # title for scale
                          num_buckets  = 7,      # number of equally-sized buckets for scale. use continuous scale if 1
                          warn_na      = FALSE,  # warn user on clipped or missing values                      
                          ggplot_scale = NULL)   # override default scale
    {
      # all input, regardless of map, is just a bunch of (region, value) pairs
      stopifnot(is.data.frame(df))
      stopifnot(c("region", "value") %in% colnames(df))
      self$df = df
      self$df = self$df[, c("region", "value")]
      
      self$title        = title
      self$scale_name   = scale_name
      stopifnot(is.numeric(num_buckets) && num_buckets > 0 && num_buckets < 10)
      self$num_buckets  = num_buckets
      self$warn_na      = warn_na
      self$ggplot_scale = ggplot_scale
    }
    
    render = function() {}),
  
  private = list(
    # 
    df            = NULL,   # input from user
    choropleth.df = NULL    # result of binding user data with our map data

    # visual appearance - users often want to tweak these options
    title         = "",     # title for map
    scale_name    = "",     # title for scale
    num_buckets   = 7,      # number of equally-sized buckets for scale. use continuous scale if 1
    regions       = NULL,   # if not NULL, only render the regions listed
    
    # less common options
    warn_na       = FALSE,  # warn user on clipped or missing values                      
    ggplot_scale  = NULL,   # override default scale

    # information about the map
    map.df        = NULL,
    map.names     = NULL,
    
    
{
    df = NULL, # what user wants to visualize
    title 
    map = NULL, # geometry we're matching df to. Every child class needs to set this itself
    warn = FALSE, # if true, emit warning when we clip values or user supplies NA values
    num_buckets = NULL, # currently our only scaling option is to equally size buckets
    
    default_continuous_scale = scale_fill_continuous(scale_name, labels=comma, na.value="black", limits=c(min, max))   
    default_discrete_scale =   scale_fill_brewer(scaleName, drop=FALSE, labels=comma, na.value="black")

    
    clip = function() {},
    
    # for us, discretizing values means 
    # 1. breaking the values into num_buckets equal intervals
    # 2. formatting the intervals e.g. with commas
    #' @importFrom Hmisc cut2    
    discretize = function() 
    {
      if (is.numeric(self$df$value) && self$num_buckets > 1) {
        self$df$value = discretize_values(df$value, num_buckets)
      
        # if cut2 uses scientific notation,  our attempt to put in commas will fail
        scipen_orig = getOption("scipen")
        options(scipen=999)
        self$df$value = cut2(self$df$value, g = self$num_buckets)
        options(scipen=scipen_orig)
        
        levels(self$df$value) = sapply(levels(self$ret), format_levels)
      }
    },
    bind = function() {},
                  
    )
                
                continuous_scale= ...,
                discrete_scale = ...,
  ),
  
  methods = list(
                initialize = function(x = 1) .self$x <- x,
                clip = function() {},
                discretize = function() {},
                bind = function() {},
                render = function() {}
  )
)