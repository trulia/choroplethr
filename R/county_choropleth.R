# This is unfortunately necessary to have R CMD check not throw out spurious NOTEs when using ggplot2
# http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("map.counties", "long", "lat", "group", "value", "label", "zipcode", "longitude", "latitude", "value"))
}

county_fips_has_valid_state = function(county.fips, vector.of.valid.state.fips)
{
  # technically a county fips should always be 5 characters, but in practice people often
  # drop the leading 0. See http://en.wikipedia.org/wiki/FIPS_county_code
  ret = logical(0)
  
  for (fips in county.fips)
  {
    stopifnot(nchar(fips) == 4 || nchar(fips) == 5)
    if (nchar(fips) == 4) {
      state = substr(fips, 1, 1)
    } else {
      state = substr(fips, 1, 2)
    }
    ret = c(ret, state %in% vector.of.valid.state.fips)
  }
  
  ret
}

county_clip = function(df, states)
{
  # if someone gives us county fips codes with leading 0's, remove them.
  # although leading 0's are correct, some people do not use them.  It is easier to 
  # convert to numeric than character - converting to numeric is not ambiguous.
  if (is.factor(df$region))
  {
    df$region = as.character(df$region)
  }  
  if (is.character(df$region))
  {
    df$region = as.numeric(df$region)
  }    
  
  # remove values that are not on our map at all
  data(map.counties, package="choroplethr", envir=environment())
  df = df[df$region %in% map.counties$county.fips.numeric, ]
  
  data(state.names, package="choroplethr", envir=environment())
  state.fips.to.render = state.names[state.names$abb %in% states, "fips.numeric"]
  
  df[county_fips_has_valid_state(df$region, state.fips.to.render), ]
}

#' @importFrom plyr rename join
county_bind = function(df, warn_na = TRUE)
{
  stopifnot(c("region", "value") %in% colnames(df))
  stopifnot(class(df$region) %in% c("character", "numeric", "integer"))

  df$region = as.numeric(df$region)
  df = rename(df, replace=c("region" = "county.fips.numeric"))
  
  data(map.counties, package="choroplethr", envir=environment())
  choropleth = join(map.counties, df, by="county.fips.numeric", type="left")
  missing_fips = unique(choropleth[is.na(choropleth$value), ]$county.fips);
  # county FIPS code 11001 is Washington DC, which choroplethr currently does not support
  # because it is not part of state.abb. However, it's in the map so it always triggers a warning
  missing_fips = setdiff(missing_fips, "11001") 
  if (warn_na && length(missing_fips) > 0)
  {
    missing_fips = paste(missing_fips, collapse = ", ");
    warning_string = paste("The following counties were missing and are being set to NA:", missing_fips);
    print(warning_string);
  }

  choropleth = choropleth[order(choropleth$order), ];
  
  choropleth
}

county_render_helper = function(choropleth.df, state.df, scaleName, theme, min, max)
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

county_render = function(choropleth.df, title, scaleName, states, renderAsInsets)
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

    alaska.ggplot = county_render_helper(alaska.df, alaska.state.df, "", theme_inset(), min_val, max_val)    
    alaska.grob   = ggplotGrob(alaska.ggplot)
    
    # subset HI and render it
    hawaii.df       = choropleth.df[choropleth.df$STATE==get_state_fips_from_abb("HI"), ]
    hawaii.state.df = choropleth.df[choropleth.df$region=='hawaii',]
    
    hawaii.ggplot = county_render_helper(hawaii.df, hawaii.state.df, "", theme_inset(), min_val, max_val)
    hawaii.grob   = ggplotGrob(hawaii.ggplot)
    
    # remove AK and HI from the "real" df
    choropleth.df = choropleth.df[!choropleth.df$STATE %in% get_state_fips_from_abb(c("AK", "HI")), ]
    state.df      = state.df[!state.df$region %in% c("alaska", "hawaii"),]
  }
  
  choropleth = county_render_helper(choropleth.df, state.df, scaleName, theme_clean(), min_val, max_val) + ggtitle(title)
  
  if (states == state.abb && renderAsInsets)
  {
    choropleth = choropleth + 
      annotation_custom(grobTree(hawaii.grob), xmin=-107.5, xmax=-102.5, ymin=25, ymax=27.5) +
      annotation_custom(grobTree(alaska.grob), xmin=-125, xmax=-110, ymin=22.5, ymax=30)    
  }
  
  choropleth
}

#' @export
county_choropleth = function(df, 
                             title          = "", 
                             scaleName      = "", 
                             num_buckets    = 7,
                             warn_na        = FALSE,
                             states         = state.abb, 
                             renderAsInsets = TRUE)
{
  df = county_clip(df, states) # remove elements we won't be rendering
  df = discretize(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = county_bind(df, warn_na) # bind df to map
  county_render(choropleth.df, title, scaleName, states, renderAsInsets) # render map
}