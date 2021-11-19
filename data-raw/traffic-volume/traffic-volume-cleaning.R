library(dplyr)
library(stringr)
library(tidyr)
library(readr)
# investigate location data
location_data <- read.csv('tmcs_locations.csv')
# after column 10, they have type of vehicles that crosses the intersection
location_counts <- read.csv('latest-counts-by-location.csv')

# how does this data relate to our schema design
# we can record the number unique street names that exist
# we can record the intersections that exist
# for each street we can count the number of intersections that occur
# then average the traffic volume for that street

# get total vehicle count for each intersection
intersection_counts <- location_counts %>%
  mutate(count = rowSums(location_counts[, 11:58])) %>%
  select(location, count)

# group by intersection and get the average traffic volume per each intersection
intersection_counts <- intersection_counts %>%
  group_by(location) %>%
  summarise(avg = mean(count))

# remove the rows containing "&" character
# grep before the (PX..) pattern 
# split into two new rows before and after "AT"

# get unique street names
intersections_names <- unique(location_counts$location) #596 unique entries
# there are intersections we 3 streets and those intersections. We are going to ignore those for now
intersection_clean <- intersection_counts %>%
  filter( !grepl('&', location)) %>%
  separate(location, c("street1", "street2"), " AT ")

intersection_clean <- na.omit(intersection_clean)

intersection_clean$street2 <- word(intersection_clean$street2,1,sep = " \\(PX.*")

intersection_clean <- intersection_clean %>%
  mutate(street1 = tolower(street1), street2 = tolower(street2))

# store the intersection names in csv files
readr::write_csv(intersection_clean[, -1], "intersection_clean.csv")

# add the traffic averages for each street
traffic_avg_street1 <- intersection_clean %>%
  select(street1, avg) %>%
  group_by(street1) %>%
  summarise(count = sum(avg)) %>%
  rename(street = street1)

traffic_avg_street2 <- intersection_clean %>%
  select(street2, avg) %>%
  group_by(street2) %>%
  summarise(count = sum(avg)) %>%
  rename(street = street2)

street_traffic_avg <- union_all(traffic_avg_street1, traffic_avg_street2)

street_traffic_avg <- street_traffic_avg %>% group_by(street) %>% summarise( count = sum(count))

unique(street_traffic_avg$street)

street_traffic_avg <- street_traffic_avg %>%
  mutate(street = tolower(street))

#store avg traffic per street 
readr::write_csv(street_traffic_avg, "traffic_volume_by_streets.csv")
