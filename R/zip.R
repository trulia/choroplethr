#' Create a county-level choropleth
#' @export
#' @importFrom dplyr left_join
#' @include usa.R
ZipMap = R6Class("CountyChoropleth",
  inherit = USAChoropleth,
  
  public = list(
    # this map looks better with an outline of the states added
#    add_state_outline = TRUE, 
    
    # there are lots of ZIPs in the official list that don't exist in any meaningful sense.
    # because of that, just delete them by default
    rm_na = TRUE, 
    
    # initialize with us state map
    initialize = function(user.df)
    {
      # load zip code data 
      data(zipcode, package="zipcode")
      
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
      
      # there are lots of zips in the zipcode that are not "real" zips, and so 
      # warning on them would likely do more harm than good
      self$warn = FALSE
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
    render = function(num_buckets=7)
    {
      stopifnot(num_buckets > 0 && num_buckets < 10)
      self$num_buckets = num_buckets
      
      self$prepare_map()
      
      # subset AK and render it
      alaska.df     = self$choropleth.df[self$choropleth.df$state=='alaska',]
      alaska.ggplot = self$render_helper(alaska.df, "", self$theme_inset())
      alaska.grob   = ggplotGrob(alaska.ggplot)
      
      # subset HI and render it
      hawaii.df     = self$choropleth.df[self$choropleth.df$state=='hawaii',]
      hawaii.ggplot = self$render_helper(hawaii.df, "", self$theme_inset())
      hawaii.grob   = ggplotGrob(hawaii.ggplot)
      
      # remove AK and HI from the "real" df
      continental.df = self$choropleth.df[!self$choropleth.df$state %in% c("alaska", "hawaii"), ]
      continental.ggplot = self$render_helper(continental.df, self$scale_name, self$theme_clean()) + ggtitle(self$title)
      
      continental.ggplot + 
        annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
        annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30) +   
        ggtitle(self$title)
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
      } else if (self$num_buckets == 1) {
        
        min_value = min(self$choropleth.df$value, na.rm=TRUE)
        max_value = max(self$choropleth.df$value, na.rm=TRUE)
        stopifnot(!is.na(min_value) && !is.na(max_value))
        
        scale_fill_continuous(self$legend_name, labels=comma, na.value="black", limits=c(min_value, max_value))
      } else {
        scale_color_brewer(self$legend_name, drop=FALSE, labels=comma, na.value="black")        
      }
    }
  )
)

#' Create a map visualizing US ZIP codes with sensible defaults.
#' 
#' @param df A data.frame with a column named "region" and a column named "value".  
#' @param title An optional title for the map.  
#' @param legend_name An optional name for the legend.  
#' @param num_buckets The number of equally sized buckets to places the values in.  A value of 1 
#' will use a continuous scale, and a value in [2, 9] will use that many buckets. 
#' 
#' @examples
#' data(df_pop_zip)
#' zip_map(df_pop_zip, title="US 2012 Population Estimates", legend_name="Population")
#'
#' @export
#' @importFrom Hmisc cut2
#' @importFrom stringr str_extract_all
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_brewer ggtitle theme theme_grey element_blank geom_text
#' @importFrom ggplot2 scale_fill_continuous scale_color_brewer geom_point
#' @importFrom scales comma
#' @importFrom grid unit
#'@include choropleth.R
zip_map = function(df, title="", legend_name="", num_buckets=7)
{
  m = ZipMap$new(df)
  m$title       = title
  m$legend_name = legend_name
  
  m$render(num_buckets)
}
