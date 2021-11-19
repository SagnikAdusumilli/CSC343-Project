library(dplyr)
library(stringr)
library(tidyr)
library(readr)
# no postal code
bikeshare_q1 <- read.csv("2021-01.csv")
# no postal code here as well
# bikeshare_q2 <- read.csv("bike-share-ridership-2021-02.csv")
# bikeshare_2018 <- read.csv("bikeshare2018.csv")

# get in checkout and checkoutTotal
# create a column called atStation

# checkInCount
# for each station id, count the number of times endStation.id has occurs
checkin_data <- bikeshare_q1 %>%
  select(End.Station.Id) %>%
  rename(station_id = End.Station.Id) %>%
  group_by(station_id) %>%
  mutate(checkin_total = n()) %>%
  distinct()

checkout_data <- bikeshare_q1 %>%
  select(Start.Station.Id) %>%
  rename(station_id = Start.Station.Id) %>%
  group_by(station_id) %>%
  mutate(checkout_total = n()) %>%
  distinct()

# natural join the two stations on station_id
station_data_clean <- merge(checkin_data, checkout_data, by="station_id", all=F)

# for each station, get station name
station_names <- bikeshare_q1 %>%
  select(Start.Station.Name, Start.Station.Id) %>%
  rename(station_name = Start.Station.Name, station_id = Start.Station.Id) %>%
  distinct()

station_data_clean <- 
  merge(station_data_clean, station_names,
        by="station_id", all=F)
# check which station names has the word "Station" in it
station_rows <- station_data_clean %>%
  select(station_name) %>%
  filter(grepl("Station", station_name)) %>%
  distinct()

station_data_clean$at_ttc <- ifelse(station_data_clean$station_name %in%
                                      station_rows$station_name, TRUE, FALSE)

# create 2 columns for the street names
station_data_clean <- station_data_clean %>%
  separate(station_name, c("street1", "street2"), " / ")

station_data_clean$street2 <- station_data_clean$street2 %>% replace_na("")

station_data_clean <-
  station_data_clean %>%
  mutate(street1 = tolower(street1), street2 = tolower(street2))
#save csv
readr::write_csv(station_data_clean, "bike_share_clean.csv")



