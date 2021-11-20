library(dplyr)
#fields for steets table
# stName
# trafficCountAvg, trafficlightCount, #done
# bikeStationCount #done
# subwayStation count #done
# bikeshopCount #done

# streets
streets <- NULL

#load traffic data
traffic_data <- read.csv("street_traffic_data.csv")

streets$stName <- traffic_data$street
streets$trafficCountAvg <- traffic_data$avg_volume
streets$trafficlightCount <- traffic_data$lightCount
streets <- as.data.frame(streets)

streets <- streets %>%
  group_by(stName) %>%
  mutate(trafficlightCount = sum(trafficlightCount)) %>%
  distinct()

#load bikestation data
bike_station_data <- read.csv("bike_share_clean.csv")
# for each street count how many occurrences happen for bikes share street one
match1 <- as.data.frame(table(streets$stName[match(bike_station_data$street1, streets$stName)]))
match2 <- as.data.frame(table(streets$stName[match(bike_station_data$street2, streets$stName)]))

match_bike_counts <- union_all(match1, match2) %>%
  group_by(Var1) %>%
  summarise(Freq = sum(Freq)) %>%
  distinct()

streets_with_bike_station <- streets$stName %in% match_bike_counts$Var1

streets$bikeStationCount <- 0
streets[streets_with_bike_station,]$bikeStationCount = match_bike_counts$Freq

#subway station count
subway_station_data <- read.csv("ttc_data_clean.csv")
streets$subwayStationCount <- 0

# remove space from both names and compare
root_st_names <- gsub("\\s*\\w*$", "", streets$stName)
subway_match <- 
  as.data.frame(table(streets$stName[match(subway_station_data$Station, root_st_names)]))

streets_with_subway <- streets$stName %in% subway_match$Var1
streets[streets_with_subway,]$subwayStationCount = subway_match$Freq

# bikeshop count
streets$bikeShopCount <- 0
bikeshop_data <- read.csv("bike_shop.csv")

#remove bikeshops that are not in know streets
bikeshop_data <- bikeshop_data[bikeshop_data$stName %in% streets$stName,]

bikeshop_match <-  
  as.data.frame(table(streets$stName[match(bikeshop_data$stName, streets$stName)]))

streets_with_bikeshops <- streets$stName %in% bikeshop_match$Var1
streets[streets_with_bikeshops,]$bikeShopCount = bikeshop_match$Freq

write.csv(streets, "streets.csv", row.names = F)

#rename intersection clean data
intersection_clean <- read.csv("intersection_clean.csv")

#write bike shops
write.csv( bikeshop_data, "bike_shop.csv", row.names = F)

# #fix subway station data
# subway_station_data <- subway_station_data %>%
#   rename(stationName = Station,
#         totalUsage = Total,
#         hasBikeStation = has_bike_station,
#         hasRepairStation = has_repair_station)
# 
# write.csv(subway_station_data, "ttc_data_clean.csv", row.names = F)

#fix bikestation data
bike_station_data <- bike_station_data %>%
  select(station_id, checkin_total, checkout_total) %>%
  rename(id = station_id, checkinAvg = checkin_total, checkoutAvg = checkout_total)

write.csv(bike_station_data, "bike_station_data.csv", row.names = F)

# fix parking data
bike_parking_data <- read.csv("parking.csv")
bike_parking_data <- bike_parking_data[bike_parking_data$stName %in% streets$stName,]
write.csv(bike_parking_data, "parking.csv", row.names = F)
