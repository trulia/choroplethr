# This class handles issues common to all USA choropleths.  Namely rendering AK and HI as insets
#' @importFrom R6 R6Class
USAChoropleth = R6Class("USAChoropleth",
  inherit = Choropleth,
  public = list(
    states = NA, # subsetting USA maps happens at the state level
   
   # explain what num_buckets means
   render = function(num_buckets=7) 
   {
     stopifnot(num_buckets > 1 && num_buckets < 10)
     private::num_buckets = num_buckets
     
     private$prepare_map()
     
     ggplot(private$choropleth.df, aes(long, lat, group = group)) +
       geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
       get_scale() +
       theme_clean()
   }
 ),
 
 private = list(

 

 )
)