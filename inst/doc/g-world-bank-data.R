## ----, hold=TRUE, warning=FALSE, message=FALSE---------------------------
library(choroplethr)
library(WDI) 

choroplethr_wdi(code="SP.POP.TOTL", year=2012, title="2012 Population", buckets=1)

## ----, hold=TRUE, warning=FALSE, message=FALSE---------------------------
choroplethr_wdi(code="SP.DYN.LE00.IN", year=2012, title="2012 Life Expectancy")

## ----, hold=TRUE, warning=FALSE, message=FALSE---------------------------
choroplethr_wdi(code="NY.GDP.PCAP.CD", year=2012, title="2012 Per Capita Income")

