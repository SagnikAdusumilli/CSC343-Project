library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(tm)
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

# remove non numerical values from street names
intersection_clean$street1 = removeNumbers(intersection_clean$street1)
intersection_clean$street2 = removeNumbers(intersection_clean$street2)

intersection_clean$street1 = trimws(intersection_clean$street1, which = c("left"))
intersection_clean$street2 = trimws(intersection_clean$street2, which = c("left"))

# combine frequency for the streets



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

street_traffic_avg <- street_traffic_avg %>% group_by(street) %>% summarise( avg_volume = sum(count))

unique(street_traffic_avg$street)

street_traffic_avg <- street_traffic_avg %>%
  mutate(street = tolower(street))

# get frequency of redlights for street 1
street1_redlight_counts <- intersection_clean %>%
  select(street1) %>%
  group_by(street1) %>%
  mutate(lightCount = n()) %>%
  rename(street = street1)

# get frequency of 
street2_redlight_counts <- intersection_clean %>%
  select(street2) %>%
  group_by(street2) %>%
  mutate(lightCount = n()) %>%
  rename(street = street2)

street_redlight_counts <- union(street1_redlight_counts, street2_redlight_counts)

street_traffic_data <- merge(street_traffic_avg, street_redlight_counts, by="street")
  

#store avg traffic per street 
readr::write_csv(street_traffic_data, "../../data-clean/street_traffic_data.csv")
