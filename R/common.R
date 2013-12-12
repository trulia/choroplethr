library(ggplot2)
library(maps)
library(gdata)
library(scales)
library(zipcode)

# this code comes from section 13.19 "Making a Map with a Clean Background"
# of "R Graphics Cookbook" by Winston Chang.  Reused with permission.
# Create a theme with many of the background elements removed
theme_clean = function(base_size = 12)
{
  require(grid); #needed for unit() function
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

generate_values = function(values, num_buckets, roundLabel = T)
{
  q = quantile(values, probs = seq(0, 1, 1/num_buckets));
  if (roundLabel)
  {
    q = round(q);
  }

  # add commas to the legend
  cut(values, 
      breaks         = q, 
      include.lowest = T, 
      labels = paste( 
        "(", 
        format(q[1:(length(q)-1)], 
               big.mark   = ",",
               scientific = F,
               digits     = 3), 
        ", ", 
        format(q[-1], 
               big.mark   = ",",
               scientific = F,
               digits     = 3), 
        "]", 
        sep = ""));     
}