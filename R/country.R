if (base::getRversion() >= "2.15.1") {
  utils::globalVariables(c("country.map", "country.names"))
}

country_clip = function(df, countries)
{
  data(country.names, package="choroplethr", envir=environment())
  stopifnot(countries %in% country.names$region)
  stopifnot(!any(duplicated(countries)))
  
  df = df[df$region %in% countries, ]
  df
}

country_bind = function(df, warn_na)
{
  stopifnot(c("region", "value") %in% colnames(df))
 
  df$region = tolower(df$region)

  data(country.map, package="choroplethr", envir=environment())
  choropleth = merge(country.map, df, all.x=TRUE)
  
  missing_countries = unique(choropleth[is.na(choropleth$value), ]$region);
  if (warn_na && length(missing_countries) > 0)
  {
    missing_countries = paste(missing_countries, collapse = ", ");
    warning_string = paste("The following countries were missing and are being set to NA:", missing_countries);
    print(warning_string);
  }
  
  choropleth = choropleth[order(choropleth$order), ];
  
  choropleth
}

country_render = function(choropleth.df, title, scaleName, countries)
{
  # only show the states the user asked
  choropleth.df = choropleth.df[choropleth.df$region %in% countries, ]
  
  # maps with numeric values are mapped with a continuous scale
  if (is.numeric(choropleth.df$value))
  {
    choropleth = ggplot(choropleth.df, aes(long, lat, group = group)) +
                     geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
                     scale_fill_continuous(scaleName, labels=comma, na.value="black") + # use a continuous scale
                     ggtitle(title) +
                     theme_clean();
  } else { # assume character or factor
    stopifnot(length(unique(na.omit(choropleth.df$value))) <= 9) # brewer scale only goes up to 9

    choropleth = ggplot(choropleth.df, aes(long, lat, group = group)) +
                     geom_polygon(aes(fill = value), color = "dark grey", size = 0.2) + 
                     scale_fill_brewer(scaleName, labels=comma, na.value="black") + # use discrete scale for buckets
                     ggtitle(title) +
                     theme_clean();
  } 
 
  choropleth
}

#' @export
country_choropleth = function(df, 
                              title       = "", 
                              scaleName   = "",
                              num_buckets = 7,
                              warn_na     = FALSE,
                              countries   = NULL)
{
  stopifnot(!any(duplicated(df$region)))
  
  # test for valid countries
  if (!is.null(countries))
  {
    data(country.names, package="choroplethr", envir=environment())
    stopifnot(countries %in% country.names$region)
    stopifnot(!any(duplicated(countries)))
  } else {
    data(country.names, package="choroplethr", envir=environment())
    countries = country.names$region
  }
  
  df$region = tolower(df$region)
  
  df = country_clip(df, countries=countries) # remove elements we won't be rendering
  df = discretize(df, num_buckets) # if user requested, discretize the values
  
  choropleth.df = country_bind(df, warn_na) # bind df to map
  country_render(choropleth.df, title, scaleName, countries) # render map
}