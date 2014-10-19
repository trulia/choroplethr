#' @importFrom R6 R6Class
#' @importFrom scales comma
#' @importFrom ggplot2 scale_color_continuous
Choropleth = R6Class("Choropleth", 
                     
  public = list(
    # the key objects for this class
    user.df       = NULL, # input from user
    map.df        = NULL, # geometry of the map
    choropleth.df = NULL, # result of binding user data with our map data
            
    title        = "",    # title for map
    legend       = "",    # title for legend
    warn         = TRUE,  # warn user on clipped or missing values                      
    ggplot_scale = NULL,  # override default scale.
                          # warning, you need to set "drop=FALSE" for insets to render correctly
    
    # a choropleth map is defined by these two variables
    # a data.frame of a map
    # a data.frame that expresses values for regions of each map
    initialize = function(map.df, user.df)
    {
      stopifnot(is.data.frame(map.df))
      stopifnot("region" %in% colnames(map.df))
      self$map.df = map.df
      
      # all input, regardless of map, is just a bunch of (region, value) pairs
      stopifnot(is.data.frame(user.df))
      stopifnot(c("region", "value") %in% colnames(user.df))
      self$user.df = user.df
      self$user.df = self$user.df[, c("region", "value")]
      
      # things like insets won't color properly if they are characters, and not factors
      if (is.character(self$user.df$value))
      {
        self$user.df$value = as.factor(self$user.df$value)
      }
      
      # initialize the map to the max zoom - i.e. all regions
      self$set_zoom(NULL)
      
      # if the user's data contains values which are not on the map, 
      # then emit a warning if appropriate
      if (self$warn)
      {
        all_regions = unique(self$map.df$region)
        user_regions = unique(self$user.df$region)
        invalid_regions = setdiff(user_regions, all_regions)
        if (length(invalid_regions) > 0)
        {
          invalid_regions = paste(invalid_regions, collapse = ", ")
          warning(paste0("Your data.frame contains the following regions which are not mappable: ", invalid_regions))
        }
      }
      
    },

    render = function() 
    {      
      self$prepare_map()
      
      ggplot(self$choropleth.df, aes(long, lat, group = group)) +
        geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
        self$get_scale() +
        self$theme_clean() + 
        ggtitle(self$title)
    },
        
    # support e.g. users just viewing states on the west coast
    clip = function() {
      stopifnot(!is.null(private$zoom))
      
      self$user.df = self$user.df[self$user.df$region %in% private$zoom, ]
      self$map.df  = self$map.df[self$map.df$region %in% private$zoom, ]
    },
    
    # for us, discretizing values means 
    # 1. breaking the values into buckets equal intervals
    # 2. formatting the intervals e.g. with commas
    #' @importFrom Hmisc cut2    
    discretize = function() 
    {
      if (is.numeric(self$user.df$value) && private$buckets > 1) {
        
        # if cut2 uses scientific notation,  our attempt to put in commas will fail
        scipen_orig = getOption("scipen")
        options(scipen=999)
        self$user.df$value = cut2(self$user.df$value, g = private$buckets)
        options(scipen=scipen_orig)
        
        levels(self$user.df$value) = sapply(levels(self$user.df$value), self$format_levels)
      }
    },
    
    bind = function() {
      self$choropleth.df = left_join(self$map.df, self$user.df, by="region")
      missing_regions = unique(self$choropleth.df[is.na(self$choropleth.df$value), ]$region)
      if (self$warn && length(missing_regions) > 0)
      {
        missing_regions = paste(missing_regions, collapse = ", ");
        warning_string = paste("The following regions were missing and are being set to NA:", missing_regions);
        print(warning_string);
      }
      
      self$choropleth.df = self$choropleth.df[order(self$choropleth.df$order), ];
    },
    
    prepare_map = function()
    {
      self$clip() # clip the input - e.g. remove value for Washington DC on a 50 state map
      self$discretize() # discretize the input. normally people don't want a continuous scale
      self$bind() # bind the input values to the map values
    },
    
    #' @importFrom scales comma
    get_scale = function()
    {
      if (!is.null(self$ggplot_scale)) 
      {
        self$ggplot_scale
      } else if (private$buckets == 1) {
        
        min_value = min(self$choropleth.df$value, na.rm = TRUE)
        max_value = max(self$choropleth.df$value, na.rm = TRUE)
        stopifnot(!is.na(min_value) && !is.na(max_value))

        # by default, scale_fill_continuous uses a light value for high values and a dark value for low values
        # however, this is the opposite of how choropleths are normally colored (see wikipedia)
        # these low and high values are from the 7 color brewer blue scale (see colorbrewer.org)
        scale_fill_continuous(self$legend, low="#eff3ff", high="#084594", labels=comma, na.value="black", limits=c(min_value, max_value))
      } else {
        scale_fill_brewer(self$legend, drop=FALSE, labels=comma, na.value="black")        
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
    },
  
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
    },
    
    set_zoom = function(zoom)
    {
      if (is.null(zoom))
      {
        # initialize the map to the max zoom - i.e. all regions
        private$zoom = unique(self$map.df$region)      
      } else {
        stopifnot(all(zoom %in% unique(self$map.df$region)))
        private$zoom = zoom
      }
    },
    get_zoom = function() { private$zoom },
    
    set_buckets = function(buckets)
    {
      # if R's ?is.integer actually tested if a value was an integer, we could replace the 
      # first 2 tests with is.integer(buckets)
      stopifnot(is.numeric(buckets) 
                && buckets%%1 == 0 
                && buckets > 0 
                && buckets < 10)
      
      private$buckets = buckets      
    }
  ),
  
  private = list(
    zoom    = NULL, # a vector of regions to zoom in on. if NULL, show all
    buckets = 7,     # number of equally-sized buckets for scale. if 1 then use a continuous scale
    has_invalid_regions = FALSE
  )
)
