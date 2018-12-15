fire_dept <- read.csv('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_2.csv', header = T, stringsAsFactors = F)
addresses <- read.csv('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_addresses.csv', header = TRUE, stringsAsFactors = FALSE)

#Now, get the distance from the fire station
addresses$lt_10 <- 0
addresses$lt_10[addresses$Fire.Station < 10] <- 1
addresses$Fire.Station <- as.character(addresses$Fire.Station)
addresses$Fire.Station[addresses$lt_10 == 1] <- paste0("0",addresses$Fire.Station)

fire_dept <- merge(fire_dept, addresses, by.x = 'station_area', by.y = 'Fire.Station', all.x = TRUE)

library(reshape2)
fire_dept$incident_latitude <- colsplit(string=fire_dept$location, pattern=",", names=c("incident_latitude", "incident_longitude"))[,1]
fire_dept$incident_longitude <- colsplit(string=fire_dept$location, pattern=",", names=c("incident_latitude", "incident_longitude"))[,2]

fire_dept$incident_latitude <- gsub("\\(","", fire_dept$incident_latitude)
fire_dept$incident_longitude <- gsub("\\)","", fire_dept$incident_longitude)
fire_dept$incident_latitude <- as.numeric(fire_dept$incident_latitude)
fire_dept$incident_longitude <- as.numeric(fire_dept$incident_longitude)

distance_euclid <- function(lat1,lon1,lat2,lon2)
{
  distance <- sqrt(((lat1-lat2)^2) + ((lon1-lon2)^2))
  return(distance)
}
fire_dept$distance_from_station <- distance_euclid(fire_dept$incident_latitude, fire_dept$incident_longitude, fire_dept$Latitude, fire_dept$Longitude)
plot(x = fire_dept$distance_from_station, y = fire_dept$total_response_time)

cols_w_na <- names(which(colSums(is.na(fire_dept))>0))
#Zipcode has ~ 1800 NAs, replace them with 0 as a different level
fire_dept$zipcode[is.na(fire_dept$zipcode)] <- 'Not available'
#Some station numbers are unavailable, this will fuck with us
fire_dept <- fire_dept[!is.na(fire_dept$distance_from_station),]
#All the other columns don't really matter
#Extreme values
summary(fire_dept$total_response_time)
sum(fire_dept$total_response_time > 10000)
#There are 23 cases where the total response time is > 10000 secs, or >2.5 hours. Let's find out what that's about.
long_time <- fire_dept[fire_dept$total_response_time > 10000,]
fire_dept <- fire_dept[fire_dept$total_response_time <= 10000,]

fire_dept$call_date <- as.Date(fire_dept$call_date)
fire_dept <- fire_dept[fire_dept$call_date >= '2014-10-01',]


#Set a whole bunch of variables as factors
fire_dept$station_area <- as.factor(fire_dept$station_area)
fire_dept$hour_of_day <- as.factor(fire_dept$hour_of_day)
fire_dept$call_type <- as.factor(fire_dept$call_type)
fire_dept$zipcode <- as.factor(fire_dept$zipcode)
fire_dept$original_priority <- as.factor(fire_dept$original_priority)
fire_dept$weather_description <- as.factor(fire_dept$weather_description)
fire_dept$battalion <- as.factor(fire_dept$battalion)
fire_dept$unit_type <- as.factor(fire_dept$unit_type)
fire_dept$neighbourhood_dist <- as.factor(fire_dept$neighbourhood_dist)
fire_dept$als_unit <- as.factor(fire_dept$als_unit)

saveRDS(fire_dept,'~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept.Rda')
fire_dept <- readRDS('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept.Rda')

sample_size <- floor(0.6 * nrow(fire_dept))
set.seed(20)
train_index <- sample(seq_len(nrow(fire_dept)), size = sample_size)
fire_train <- fire_dept[train_index,]
remain40 <- fire_dept[-train_index,]
test_valid_index <- sample(seq_len(nrow(remain40)), 0.5*nrow(remain40))
fire_validn <- remain40[test_valid_index,]
fire_test <- remain40[-test_valid_index,]

summary(fire_train$total_response_time)
sd(fire_train$total_response_time)


#Linear regression model
response_time_lm <- lm(total_response_time ~ station_area+hour_of_day+call_type+battalion+als_unit+
                         weather_description+temperature+final_priority+unit_type+
                         wind_speed+distance_from_station+number_of_alarms, fire_train)
summary(response_time_lm)
fire_validn$predicted_response_time <- predict(object = response_time_lm, fire_validn)

response_time_lm_2 <- lm(total_response_time ~ station_area+hour_of_day+battalion+als_unit+
                         weather_description+temperature+final_priority+unit_type+
                         distance_from_station, fire_train)
summary(response_time_lm_2)
fire_validn$predicted_response_time <- predict(object = response_time_lm_2, fire_validn)

rmse <- function(actual, predicted){
  sqrt(mean((actual - predicted)^2))
}
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)

#Decision tree regressor
library(rpart)
dtree_4 <- rpart(total_response_time ~ station_area+hour_of_day+call_type+battalion+als_unit+
                   original_priority+weather_description+temperature+final_priority+unit_type+
                   wind_speed+distance_from_station+number_of_alarms, fire_train)

fire_validn$predicted_response_time <- predict(dtree_4,fire_validn)
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)

library(randomForest)
set.seed(20)
dtree_5 <- randomForest(total_response_time ~ hour_of_day+call_type+battalion+als_unit+
                          weather_description+temperature+final_priority+unit_type+
                          wind_speed+distance_from_station+number_of_alarms, fire_train,
                        ntree = 300, importance = TRUE)
fire_validn$predicted_response_time <- predict(dtree_5,fire_validn)
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)
