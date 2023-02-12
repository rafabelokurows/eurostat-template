library(jsonlite)
library(leaflet)
library(tidyverse)
library(eurostat)

# teste2 = geojson_read("C:\\Users\\rafae\\Downloads\\NUTS_RG_20M_2021_4326.geojson", what = "sp")
# teste2 = teste2[teste2$LEVL_CODE == 2,]
# 
# leaflet(teste2) %>%
#   addTiles() %>%
#   addPolygons(label=~NUTS_NAME)

#Geo Data 
geo2 = get_eurostat_geospatial(nuts_level = 2)

 # leaflet(geo2) %>%
 #   addTiles() %>%
 #   addPolygons(label=~NUTS_NAME)


dat2 <- get_eurostat("ei_cphi_m", time_format = "num")
cphi = dat2 %>% filter(indic == "CP-HI01" &  unit == "HICP2015") 

geo0 = get_eurostat_geospatial(nuts_level = "0")

lastcphi = cphi %>% group_by(geo) %>% summarize(val=last(values))

geo0 = geo0 %>% 
  left_join(lastcphi)


pal <- colorBin(palette = "RdYlBu", domain = geo0$val)

# leaflet(geo0) %>%
#   addCircles(lng = ~long, lat = ~lat, color = ~pal(category),
#              fillColor = ~pal(category), fillOpacity = 0.7)

leaflet(geo0) %>%
  addTiles() %>%
  addPolygons(label=~NUTS_NAME,stroke = 0.3,color = "black", fillColor = ~pal(val), fillOpacity = 0.7,
  )%>%
  addLegend(
    "topright",
    pal = colorBin('RdBu', geo0$val),
    values = geo0$val, 
    opacity = 0.9
  )


#Indicators that were last updated
# toc = get_eurostat_toc()
# toc %>% arrange(`last update of data`) %>% 
#   filter(str_detect(`data end`,"2023")) %>% View()
#   head(20) %>% View()



#Airport data
# dat <- get_eurostat("avia_tf_airpm", time_format = "num")
# 
# dat %>%  filter(str_detect(rep_airp,"PT_LPPR")) %>% label_eurostat() %>% 
#   mutate(time2 = eurotime2date(time,last = F)) %>% 
#   View()

