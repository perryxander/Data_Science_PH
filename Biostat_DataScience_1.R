library(tidyverse)

#NOAA Weather Data Example

weather_df = 
  rnoaa::meteo_pull_monitors(
    c("USW00094728", "USC00519397", "USS0023B17S"),
    var = c("PRCP", "TMIN", "TMAX"), 
    date_min = "2017-01-01",
    date_max = "2017-12-31") %>%
  mutate(
    name = recode(
      id, 
      USW00094728 = "CentralPark_NY", 
      USC00519397 = "Waikiki_HA",
      USS0023B17S = "Waterhole_WA"),
    tmin = tmin / 10,
    tmax = tmax / 10) %>%
  select(name, id, everything())

weather_df %>% 
  ggplot(aes(x = date, y = tmax, color = name)) + 
  geom_point(alpha = .5) +
  geom_smooth(se = FALSE) + 
  theme(legend.position = "bottom")
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'


#Airbnb example

library(leaflet)
library(p8105.datasets)

data("nyc_airbnb")

nyc_airbnb = 
  nyc_airbnb %>% 
  mutate(stars = review_scores_location / 2) %>% 
  rename(boro = neighbourhood_group)

pal <- colorNumeric(
  palette = "viridis",
  domain = nyc_airbnb$stars)

nyc_airbnb %>% 
  filter(boro %in% c("Manhattan", "Brooklyn", "Queens")) %>% 
  na.omit(stars) %>% 
  sample_n(5000) %>% 
  mutate(
    click_label = 
      str_c("<b>$", price, "</b><br>", stars, " stars<br>", number_of_reviews, " reviews")) %>% 
  leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addCircleMarkers(~lat, ~long, radius = .1, color = ~pal(stars), popup = ~click_label)





