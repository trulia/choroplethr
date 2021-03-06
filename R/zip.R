if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("country.regions"))
}

#' Create a county-level choropleth
#' @export
#' @importFrom dplyr left_join
#' @include usa.R
ZipMap = R6Class("CountyChoropleth",
  inherit = USAChoropleth,
  
  public = list(
    # this map looks better with an outline of the states added
    add_state_outline = TRUE, 
    
    # there are lots of ZIPs in the official list that don't exist in any meaningful sense.
    # because of that, just delete them by default
    rm_na = TRUE, 
    
    # initialize with us state map
    initialize = function(user.df)
    {
      # there are lots of zips in the zipcode that are not "real" zips, and so 
      # warning on them would likely do more harm than good
      self$warn = FALSE
      
      # load zip code data 
      data(zipcode, package="zipcode", envir=environment())
      
      # only include states
      zipcode = zipcode[zipcode$state %in% state.abb, ]
      # remove bad data.
      # it has two zips in NY and VA in the atlantic/europe
      zipcode = zipcode[zipcode$longitude < -10, ]
      
      # rename variables so base class can process
      names(zipcode)[names(zipcode) == "zip"      ] = "region"
      names(zipcode)[names(zipcode) == "longitude"] = "long"
      names(zipcode)[names(zipcode) == "latitude" ] = "lat"

      # USAChoropleth requires a column called "state" that has full lower case state name (e.g. "new york")
      zipcode$state = tolower(state.name[match(zipcode$state, state.abb)])

      super$initialize(zipcode, user.df)
            
      # by default, show all states on the map
      data(state.map, package="choroplethrMaps", envir=environment())
      private$zoom = unique(state.map$region)      
    },
    
    # support e.g. users just viewing states on the west coast
    clip = function() {
      # user.df has zip codes, but subsetting happens at the state level
      data(zipcode, package="zipcode", envir=environment())
      # zipcode to state abbreviation
      self$user.df$state = merge(self$user.df, zipcode, sort=FALSE, all.x=TRUE, by.x="region", by.y="zip")$state
      # state abbrevoation to "region" - lowercase full state name
      self$user.df$state = tolower(state.name[match(self$user.df$state, state.abb)])
      self$user.df = self$user.df[self$user.df$state %in% private$zoom, ]
      self$user.df$state = NULL
      
      self$map.df  = self$map.df[self$map.df$state %in% private$zoom, ]
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
      
      if (self$rm_na)
      {
        self$choropleth.df = na.omit(self$choropleth.df)
      }
    },
    
    # render the map, with AK and HI as insets
    render = function()
    {
      self$prepare_map()
      
      if (private$zoom == "alaska" || private$zoom == "hawaii") {
        choro = self$render_helper(self$choropleth.df, self$scale_name, self$theme_clean()) + ggtitle(self$title)
        if (self$add_state_outline)
        {
          choro + self$render_state_outline(private$zoom)
        }        
      } else {
        # subset AK and render it
        alaska.df     = self$choropleth.df[self$choropleth.df$state=='alaska',]
        alaska.ggplot = self$render_helper(alaska.df, "", self$theme_inset())
        if (self$add_state_outline)
        {
          alaska.ggplot = alaska.ggplot + self$render_state_outline('alaska')
        }
        alaska.grob   = ggplotGrob(alaska.ggplot)
        
        # subset HI and render it
        hawaii.df     = self$choropleth.df[self$choropleth.df$state=='hawaii',]
        hawaii.ggplot = self$render_helper(hawaii.df, "", self$theme_inset())
        if (self$add_state_outline)
        {
          hawaii.ggplot = hawaii.ggplot + self$render_state_outline('hawaii')
        }
        hawaii.grob   = ggplotGrob(hawaii.ggplot)
        
        # remove AK and HI from the "real" df
        continental.df = self$choropleth.df[!self$choropleth.df$state %in% c("alaska", "hawaii"), ]
        continental.ggplot = self$render_helper(continental.df, self$scale_name, self$theme_clean()) + ggtitle(self$title)
        if (self$add_state_outline)
        {
          continental.regions = subset(private$zoom, private$zoom!="alaska" & private$zoom!="hawaii")
          continental.ggplot = continental.ggplot + self$render_state_outline(continental.regions)
        }
        
        continental.ggplot + 
          annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
          annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30) +   
          ggtitle(self$title)
      }
    },
    
    render_helper = function(choropleth.df, scale_name, theme)
    {
      if (is.numeric(choropleth.df$value))
      {
        ggplot(choropleth.df, aes(x=long, y=lat, color=value)) +
          geom_point() +
          self$get_scale() +
          theme;
      } else { # assume character or factor
        stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
        
        ggplot(choropleth.df, aes(x=long, y=lat, color=value)) +
          geom_point() + 
          self$get_scale() +
          theme;  
      }   
    },
    
    # we need to override this
    #' @importFrom scales comma
    get_scale = function()
    {
      if (!is.null(self$ggplot_scale)) 
      {
        self$ggplot_scale
      } else if (private$buckets == 1) {
        
        min_value = min(self$choropleth.df$value, na.rm=TRUE)
        max_value = max(self$choropleth.df$value, na.rm=TRUE)
        stopifnot(!is.na(min_value) && !is.na(max_value))
        
        # by default, scale_fill_continuous uses a light value for high values and a dark value for low values
        # however, this is the opposite of how choropleths are normally colored (see wikipedia)
        # these low and high values are from the 7 color brewer blue scale (see colorbrewer.org)
        scale_color_continuous(self$legend, low="#eff3ff", high="#084594", labels=comma, na.value="black", limits=c(min_value, max_value))
      } else {
        scale_color_brewer(self$legend, drop=FALSE, labels=comma, na.value="black")        
      }
    }
  )
)

#' Create a map visualizing US ZIP codes with sensible defaults. 
#' 
#' ZIPs are rendered as scatterplots against and outline of US States. 
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  Values of the 
#' "region" column must be valid 5-digit zip codes.
#' @param title An optional title for the map.  
#' @param legend An optional name for the legend.  
#' @param buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' @param zoom An optional vector of states to zoom in on. Elements of this vector must exactly 
#' match the names of states as they appear in the "region" column of ?state.regions.
#'  
#' @examples
#' # demonstrate default parameters - visualization using 7 equally sized buckets
#' data(df_pop_zip)
#' zip_map(df_pop_zip, title="US 2012 ZCTA Population Estimates", legend="Population")
#'
#' # demonstrate continuous scale and zoom
#' data(df_pop_zip)
#' zip_map(df_pop_zip, 
#'         title="US 2012 ZCTA Population Estimates", 
#'         legend="Population", 
#'         buckets=1, 
#'         zoom=c("california", "oregon", "washington"))
#'
#' @note The longitude and latitude of ZIPs come from the "zipcode" package. The state outlines come 
#' from ?state.map.
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_color_brewer geom_point
#' @importFrom scales comma
#' @importFrom grid unit
#'@include choropleth.R
zip_map = function(df, title="", legend="", buckets=7, zoom=NULL)
{
  m = ZipMap$new(df)
  m$title  = title
  m$legend = legend
  m$set_buckets(buckets)
  m$set_zoom(zoom)
  m$render()
}
