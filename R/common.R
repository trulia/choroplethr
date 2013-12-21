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
    panel.background  = element_blank(),
    panel.grid        = element_blank(),
    axis.ticks.length = unit(0, "cm"),
    axis.ticks.margin = unit(0, "cm"),
    panel.margin      = unit(0, "lines"),
    plot.margin       = unit(c(0, 0, 0, 0), "lines"),
    complete = TRUE
  )
}

generate_values = function(values, num_buckets)
{
  cut2(values, g=num_buckets)
}
