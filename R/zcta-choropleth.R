require("rgdal") # requires sp, will use proj.4 if installed
require("maptools")
require("ggplot2")
require("plyr")

# remaining problems:
# 1. I lost the ZCTA names.
# 2. Only keep continental US. Perhaps join with zipcode to get state, 
#    and then remove where state not %in% state.abbr
# 3. join against census data for values

#setwd('~/Desktop/tl_2013_us_zcta510/tl_2013_us_zcta510.shp')
#zips = readOGR(dsn=".", layer="tl_2013_us_zcta510")
#zips = gSimplify(m, 0.01)
#map.df = fortify(zips)
#map.df$value=sample(1:10,size=nrow(map.df),replace=T)
#ggplot(map.df, aes(long, lat, group=group)) + geom_polygon(fill=value)
