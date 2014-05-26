# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("map.counties", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

#' @importFrom plyr rename join
bind_df_to_county_map = function(df)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(class(df$region) %in% c("character", "numeric", "integer"))

  df$region = as.numeric(df$region)
  df = rename(df, replace=c("region" = "county.fips.numeric"))
  
  data(map.counties, package="choroplethr", envir=environment())
  choropleth = join(map.counties, df, by="county.fips.numeric", type="left")
  if (any(is.na(choropleth$value)))
  {
    missing_polynames = unique(choropleth[is.na(choropleth$value), ]$polyname);
    missing_polynames = paste(missing_polynames, collapse = ", ");
    warning_string    = paste("The following counties were missing and are being set to NA:", missing_polynames);
    print(warning_string);
  }

  choropleth = choropleth[order(choropleth$order), ];
  
  choropleth
}

print_county_choropleth = function(choropleth.df, state.df, scaleName, theme, min, max)
{
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_continuous(scaleName, labels=comma, na.value="black") + # use a continuous scale
      theme;
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9
    
    ggplot(choropleth.df, aes(long, lat, group = group)) +
      geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
      geom_polygon(data = state.df, color = "black", fill = NA, size = 0.2) +
      scale_fill_brewer(scaleName, labels=comma, na.value="black") + # use discrete scale for buckets
      theme;
  }
}

render_county_choropleth = function(choropleth.df, title="", scaleName="", states=state.abb, renderAsInsets=TRUE)
{
  # only show the states the user asked
  choropleth.df = choropleth.df[choropleth.df$STATE %in% get_state_fips_from_abb(states), ]
  
  # county maps really need state backgrounds
  state.df = subset_map("state", states);
  
  # if user requested to render all 50 states, 
  # create separate data.frames for AK and HI and render them as separate images
  # cache min, max value of entire data.frame to make scales consistent between all insets s
  min_val = 0
  max_val = 0
  if (is.numeric(choropleth.df$value))
  {
    min_val = min(choropleth.df$value)
    max_val = max(choropleth.df$value)
  }
  
  if (states == state.abb && renderAsInsets)
  {
    # subset AK and render it
    alaska.df       = choropleth.df[choropleth.df$STATE==get_state_fips_from_abb("AK"), ]
    alaska.state.df = choropleth.df[choropleth.df$region=='alaska',]

    alaska.ggplot = print_county_choropleth(alaska.df, alaska.state.df, "", theme_inset(), min_val, max_val)    
    alaska.grob   = ggplotGrob(alaska.ggplot)
    
    # subset HI and render it
    hawaii.df       = choropleth.df[choropleth.df$STATE==get_state_fips_from_abb("HI"), ]
    hawaii.state.df = choropleth.df[choropleth.df$region=='hawaii',]
    
    hawaii.ggplot = print_county_choropleth(hawaii.df, hawaii.state.df, "", theme_inset(), min_val, max_val)
    hawaii.grob   = ggplotGrob(hawaii.ggplot)
    
    # remove AK and HI from the "real" df
    choropleth.df = choropleth.df[!choropleth.df$STATE %in% get_state_fips_from_abb(c("AK", "HI")), ]
    state.df      = state.df[!state.df$region %in% c("alaska", "hawaii"),]
  }
  
  choropleth = print_county_choropleth(choropleth.df, state.df, scaleName, theme_clean(), min_val, max_val) + ggtitle(title)
  
  if (states == state.abb && renderAsInsets)
  {
    choropleth = choropleth + 
      annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
      annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)    
  }
  
  choropleth
}

# this needs to be called from the main choroplethr function
county_choropleth_auto = function(df, num_buckets, title, scaleName, states, renderAsInsets)
{
  df = clip_df(df, "county", states) # remove elements we won't be rendering
  df = discretize_df(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = bind_df_to_county_map(df) # bind df to map
  render_county_choropleth(choropleth.df, title, scaleName, states, renderAsInsets) # render map
}