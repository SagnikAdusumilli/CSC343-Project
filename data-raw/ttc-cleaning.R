library(dplyr)
library(readr)
library(stringr)
ttc_data <- read.csv("ttc-usage.csv")
ttc_data_clean <- ttc_data %>%
  select(Station, Total)

ttc_data_clean$Total = as.numeric(gsub(",", "", ttc_data_clean$Total))

ttc_data_clean <- ttc_data_clean %>%
  group_by(Station) %>%
  summarise(Total = sum(Total))
  

bikeshare_data <- read.csv("../data-clean/bike_share_clean.csv")

subway_bike_stations <- bikeshare_data %>%
  filter(at_ttc == TRUE)

unique(ttc_data_clean$Station)

ttc_data_clean$Station = tolower(ttc_data_clean$Station)


#TTC with bike stations
hasBikeStations <- c("union", "victoria park", "donlands", "chester", "castle frank",
  "summerhill", "bathurst", "lansdowne", "high park", "woodbine",
  "jane", "finch", "rosedale", "greenwood")

ttc_data_clean$has_bike_station =  ifelse(ttc_data_clean$Station %in%
                                            hasBikeStations, TRUE, FALSE)

#TTC stations that have repair stands
fixit_locations <- read.csv("fixit-locations.csv")

fixit_locations$location <- tolower(fixit_locations$location)

fix_station_locations <- fixit_locations %>%
  filter(grepl("station", location)) %>%
  distinct()

fix_station_locations[3,] = "sheppard west station"

fix_station_locations$location = word(fix_station_locations$location,
                                      1,sep = " station")

ttc_data_clean$has_repair_station =  ifelse(ttc_data_clean$Station %in%
                                            fix_station_locations$location, 
                                          TRUE, FALSE)
write.csv(ttc_data_clean, "../data-clean/ttc_data_clean.csv")
