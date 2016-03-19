#' The base Choropleth object.
#' @importFrom R6 R6Class
#' @importFrom scales comma
#' @importFrom ggplot2 scale_color_continuous coord_quickmap coord_map scale_x_continuous scale_y_continuous
#' @importFrom ggmap get_map ggmap
#' @importFrom RgoogleMaps MaxZoom
#' @importFrom stringr str_extract_all
#' @export
Choropleth = R6Class("Choropleth", 
                     
  public = list(
    # the key objects for this class
    user.df        = NULL, # input from user
    map.df         = NULL, # geometry of the map
    choropleth.df  = NULL, # result of binding user data with our map data
            
    title          = "",    # title for map
    legend         = "",    # title for legend
    warn           = TRUE,  # warn user on clipped or missing values                      
    ggplot_scale   = NULL,  # override default scale.
                            # warning, you need to set "drop=FALSE" for insets to render correctly
    
    # as of ggplot v2.1.0, R6 class variables cannot be assigned to ggplot2 objects
    # in the class declaration. Doing so will break binary builds, so assign them
    # in the constructor instead
    projection     = NULL, 
    ggplot_polygon = NULL, 
      
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
      
      stopifnot(anyDuplicated(self$user.df$region) == 0)
      
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
      
      # as of ggplot v2.1.0, R6 class variables cannot be assigned to ggplot2 objects
      # in the class declaration. Doing so will break binary builds, so assign them
      # in the constructor instead
      self$projection     = coord_quickmap()
      self$ggplot_polygon = geom_polygon(aes(fill = value), color = "dark grey", size = 0.2)
      
    },

    render = function() 
    {
      self$prepare_map()
      
      ggplot(self$choropleth.df, aes(long, lat, group = group)) +
        self$ggplot_polygon + 
        self$get_scale() +
        self$theme_clean() + 
        ggtitle(self$title) + 
        self$projection
    },

    # left
    get_min_long = function() 
    {
      min(self$choropleth.df$long)
    },
    
    # right 
    get_max_long = function() 
    {
      max(self$choropleth.df$long) 
    },
    
    # bottom 
    get_min_lat = function() 
    {
      min(self$choropleth.df$lat) 
    },
    
    # top
    get_max_lat = function() 
    {
      max(self$choropleth.df$lat) 
    },
    
    get_bounding_box = function(long_margin_percent, lat_margin_percent)
    {
      c(self$get_min_long(), # left
        self$get_min_lat(),  # bottom
        self$get_max_long(), # right
        self$get_max_lat())  # top
    },
    
    get_x_scale = function()
    {
      scale_x_continuous(limits = c(self$get_min_long(), self$get_max_long()))
    },
    
    get_y_scale = function()
    {
      scale_y_continuous(limits = c(self$get_min_lat(), self$get_max_lat()))
    },
    
    get_reference_map = function()
    {
      # note: center is (long, lat) but MaxZoom is (lat, long)
      
      center = c(mean(self$choropleth.df$long), 
                 mean(self$choropleth.df$lat))

      max_zoom = MaxZoom(range(self$choropleth.df$lat), 
                         range(self$choropleth.df$long))
      
      get_map(location = center,
              zoom     = max_zoom,
              color    = "bw")  
    },
    
    get_choropleth_as_polygon = function(alpha)
    {
      geom_polygon(data = self$choropleth.df,
                   aes(x = long, y = lat, fill = value, group = group), alpha = alpha) 
    },
    
    render_with_reference_map = function(alpha = 0.5)
    {
      self$prepare_map()

      reference_map = self$get_reference_map()
      
      ggmap(reference_map) +  
        self$get_choropleth_as_polygon(alpha) + 
        self$get_scale() +
        self$get_x_scale() +
        self$get_y_scale() +
        self$theme_clean() + 
        ggtitle(self$title) + 
        coord_map()
    },
    
    # support e.g. users just viewing states on the west coast
    clip = function() {
      stopifnot(!is.null(private$zoom))
      
      self$user.df = self$user.df[self$user.df$region %in% private$zoom, ]
      self$map.df  = self$map.df[self$map.df$region %in% private$zoom, ]
    },
    
    # for us, discretizing values means 
    # 1. assigning each value to one of num_colors colors
    # 2. formatting the intervals e.g. with commas
    #' @importFrom Hmisc cut2    
    discretize = function() 
    {
      if (is.numeric(self$user.df$value) && private$num_colors > 1) {
        
        # if cut2 uses scientific notation,  our attempt to put in commas will fail
        scipen_orig = getOption("scipen")
        options(scipen=999)
        self$user.df$value = cut2(self$user.df$value, g = private$num_colors)
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
        warning(warning_string);
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
      } else if (private$num_colors == 1) {
        
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
    
    # Removes axes, margins and sets the background to white.
    # This code, with minor modifications, comes from section 13.19 
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
        panel.margin      = unit(0, "lines"),
        plot.margin       = unit(c(0, 0, 0, 0), "lines"),
        complete          = TRUE
      )
    },
  
    # Make the output of cut2 a bit easier to read
    # 
    # Adds commas to numbers, removes unnecessary whitespace and allows an arbitrary separator.
    # 
    # @param x A factor with levels created via Hmisc::cut2.
    # @param nsep A separator which you wish to use.  Defaults to " to ".
    # 
    # @export
    # @examples
    # data(df_pop_state)
    #
    # x = Hmisc::cut2(df_pop_state$value, g=3)
    # levels(x)
    # # [1] "[ 562803, 2851183)" "[2851183, 6353226)" "[6353226,37325068]"
    # levels(x) = sapply(levels(x), format_levels)
    # levels(x)
    # # [1] "[562,803 to 2,851,183)"    "[2,851,183 to 6,353,226)"  "[6,353,226 to 37,325,068]"
    #
    # @seealso \url{http://stackoverflow.com/questions/22416612/how-can-i-get-cut2-to-use-commas/}, which this implementation is based on.
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
    
    set_num_colors = function(num_colors)
    {
      # if R's ?is.integer actually tested if a value was an integer, we could replace the 
      # first 2 tests with is.integer(num_colors)
      stopifnot(is.numeric(num_colors) 
                && num_colors%%1 == 0 
                && num_colors > 0 
                && num_colors < 10)
      
      private$num_colors = num_colors      
    }
  ),
  
  private = list(
    zoom = NULL, # a vector of regions to zoom in on. if NULL, show all
    num_colors = 7,     # number of colors to use on the map. if 1 then use a continuous scale
    has_invalid_regions = FALSE
  )
)
