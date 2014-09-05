#' @importFrom R6 R6Class
#' @importFrom scales comma
Choropleth = R6Class("Choropleth", 
  public = list(
    title        = "",    # title for map
    legend_name  = "",    # title for legend
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
    },

    # explain what num_buckets means
    render = function(num_buckets=7) 
    {
      stopifnot(num_buckets > 0 && num_buckets < 10)
      self$num_buckets = num_buckets
      
      self$prepare_map()
      
      ggplot(self$choropleth.df, aes(long, lat, group = group)) +
        geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
        get_scale() +
        theme_clean() + 
        ggtitle(self$title)
    },

    # the key objects for this class
    user.df       = NULL, # input from user
    map.df        = NULL, # geometry of the map
    choropleth.df = NULL, # result of binding user data with our map data
    map.names     = NULL, # a helper object that lists various naming conventions for the regions
    
    num_buckets   = 7,      # number of equally-sized buckets for scale. use continuous scale if 1
    regions       = NULL,   # if not NULL, only render the regions listed
    
    # TODO: What if self$regions is NULL and user enters "puerto rico"?
    # TODO: need to WARN here!
    # support e.g. users just viewing states on the west coast
    clip = function() {
      if (!is.null(self$regions))
      {
        self$user.df = self$user.df[self$user.df$region %in% self$regions, ]
        self$map.df  = self$map.df[self$map.df$region %in% self$regions, ]
      }
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
    get_scale = function(min=NA, max=NA)
    {
      if (!is.null(ggplot_scale)) 
      {
        ggplot_scale
      } else if (self$num_buckets == 1) {
        stopifnot(!is.na(min) && !is.na(max))
        scale_fill_continuous(self$legend_name, labels=comma, na.value="black", limits=c(min, max))
      } else {
        scale_fill_brewer(self$legend_name, drop=FALSE, labels=comma, na.value="black")        
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
    })
)
