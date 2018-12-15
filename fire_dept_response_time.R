# fire_dept <- read.csv('~/Downloads/Datasets for analysis/Fire Department Service Calls/Fire_Department_Calls_for_Service.csv',header = FALSE, stringsAsFactors = FALSE)
# colnames(fire_dept) <- c('call_num','unit_id','incident_number','call_type','call_date','watch_date',
#                          'recd_timestamp','entry_timestamp','dispatch_timestamp','response_timestamp',
#                          'on_scene_timestamp','transport_timestamp',
#                          'hospital_timestamp','call_final_disposition','available_timestamp','address',
#                          'city','zipcode','battalion','station_area','box','original_priority','priority',
#                          'final_priority','als_unit','call_type_group','number_of_alarms','unit_type',
#                          'unit_seq_in_call_dispatch','fire_prevention_dist','supervisor_dist',
#                          'neighbourhood_dist','location','row_id')
# 
# fire_dept$call_date <- as.Date(fire_dept$call_date,'%m/%d/%Y')
# fire_dept <- fire_dept[fire_dept$call_date <= '2018-06-01' & fire_dept$call_date >= '2013-06-01',]
# write.csv(fire_dept, '/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_service_calls_13_18.csv')

#library(ggmap)
addresses <- read.csv('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_addresses.csv', header = TRUE, stringsAsFactors = FALSE)
#addresses$Address <- paste0(addresses$Address, ", USA")

#library(photon)
#geocoded <- geocode(addresses$Address, limit = 1, key = "place")
# geocoded <- data.frame(stringsAsFactors = FALSE)
# for(i in 1:nrow(addresses))
# {
#   # Print("Working...")
#   result <- geocode(addresses$Address[i], output = "latlona", source = "google")
#   addresses$lon[i] <- as.numeric(result[1,i])
#   addresses$lat[i] <- as.numeric(result[2,i])
#   addresses$geoAddress[i] <- as.character(result[3])
# }

fire_dept <- read.csv('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_ads.csv', header=T, stringsAsFactors = F)
# fire_dept$recd_timestamp <- as.POSIXct(fire_dept$recd_timestamp,'%m/%d/%Y %r', tz = 'PDT')
# fire_dept$entry_timestamp <- as.POSIXct(fire_dept$entry_timestamp,'%m/%d/%Y %r', tz = 'PDT')
# fire_dept$dispatch_timestamp <- as.POSIXct(fire_dept$dispatch_timestamp,'%m/%d/%Y %r', tz = 'PDT')
# fire_dept$response_timestamp <- as.POSIXct(fire_dept$response_timestamp,'%m/%d/%Y %r', tz = 'PDT')
# fire_dept$on_scene_timestamp <- as.POSIXct(fire_dept$on_scene_timestamp,'%m/%d/%Y %r', tz = 'PDT')
# 
# #First, checking for NULLs in the timestamp variables
# sum(!is.na(fire_dept$recd_timestamp))     #Does not contain any NAs
# sum(!is.na(fire_dept$entry_timestamp))     #Does not contain any NAs
# sum(!is.na(fire_dept$dispatch_timestamp))   #Does not contain any NAs
# sum(!is.na(fire_dept$response_timestamp))   #Contains 1431689 (~1.43M/1.48M) available values
# sum(!is.na(fire_dept$on_scene_timestamp))     # Has 1177683 (~1.17M/1.48M) available values
# 
# fire_dept <- fire_dept[!is.na(fire_dept$on_scene_timestamp),]
# 
# #Let's get the earliest response time
# earliest_response <- aggregate(on_scene_timestamp ~ call_num, fire_dept, min)
# colnames(earliest_response) <- c('call_num','on_scene_first')
# fire_dept <- merge(fire_dept, earliest_response, by.x = c('call_num','on_scene_timestamp'), by.y = c('call_num','on_scene_first'))
# 
# #Checking if there's a difference between the call received timestamp and the entry timestamp
# fire_dept$entry_time <- difftime(fire_dept$recd_timestamp, fire_dept$entry_timestamp, units = "secs")
# fire_dept$entry_time <- -fire_dept$entry_time
# length(which(as.numeric(fire_dept$entry_time) > 0)) #533941(~534k/663k) cases
# length(which(as.numeric(fire_dept$entry_time) == 0)) # 129079(~129k/663k) cases
# length(which(as.numeric(fire_dept$entry_time) < 0)) # 16 cases
# median(as.numeric(fire_dept$entry_time)) #75 seconds
# 
# fire_dept$dispatch_time <- difftime(fire_dept$entry_timestamp, fire_dept$dispatch_timestamp, units = "secs")
# fire_dept$dispatch_time <- -fire_dept$dispatch_time
# length(which(as.numeric(fire_dept$dispatch_time) < 0)) #650807(~651k/663k) cases
# length(which(as.numeric(fire_dept$dispatch_time) == 0)) # 12214(~12k) cases
# length(which(as.numeric(fire_dept$dispatch_time) > 0)) #15 cases
# median(as.numeric(fire_dept$dispatch_time)) #-32 seconds
# 
# fire_dept$response_time <- difftime(fire_dept$dispatch_timestamp, fire_dept$response_timestamp, units = "secs")
# fire_dept$response_time <- -as.numeric(fire_dept$response_time)
# length(which(as.numeric(fire_dept$response_time) > 0)) #621583(~622k/663k) cases
# length(which(as.numeric(fire_dept$response_time) == 0)) # 36219(~36k) cases
# length(which(as.numeric(fire_dept$response_time) < 0)) #80 cases
# median(na.omit(as.numeric(fire_dept$response_time))) #54 seconds
# 
# fire_dept$on_scene_time <- difftime(fire_dept$response_timestamp, fire_dept$on_scene_timestamp, units = "secs")
# fire_dept$on_scene_time <- -as.numeric(fire_dept$on_scene_time)
# length(which(as.numeric(fire_dept$on_scene_time) > 0)) #625830(~626k/663k) cases
# length(which(as.numeric(fire_dept$on_scene_time) == 0)) # 31589(~32k) cases
# length(which(as.numeric(fire_dept$on_scene_time) < 0)) #463 cases
# median(na.omit(as.numeric(fire_dept$on_scene_time))) #179 seconds
# # 

# fire_dept$total_response_time <- -(as.numeric(difftime(fire_dept$recd_timestamp, fire_dept$on_scene_timestamp, unit = "secs")))
# length(which(as.numeric(fire_dept$total_response_time) > 0)) #651084(~651k/663k) cases
# length(which(as.numeric(fire_dept$total_response_time) == 0)) # 11910(~12k) cases
# length(which(as.numeric(fire_dept$total_response_time) < 0)) #42 cases
# median(as.numeric(fire_dept$total_response_time)) #388 seconds
# 
# write.csv(fire_dept,'~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_service_calls_13_18.csv')

#None of the times being negative makes any sense - let's remove those rows
# fire_dept <- fire_dept[(fire_dept$entry_time >= 0 & fire_dept$dispatch_time >= 0 & fire_dept$response_time >= 0 & fire_dept$on_scene_time >= 0),]
#fire_dept <- fire_dept[fire_dept$call_date <= '2017-10-28',]
#write.csv(fire_dept,'~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_ads.csv')

#Now, some EDA

#Distribution of calls by district
library(ggplot2)
calls_by_district <- aggregate(call_num ~ neighbourhood_dist, fire_dept, function(x){length(unique(x))})
calls_by_district <- calls_by_district[order(-calls_by_district$call_num),]

#Plot of the the number of calls from each district for the top ten
call_district_plot<-ggplot(data=head(calls_by_district,10), aes(x=neighbourhood_dist, y=call_num)) +
  geom_bar(stat="identity", fill="steelblue")+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  ggtitle("Call Volume by District (Top 10), 2013-2018")+xlab("District")+ylab("Total Call Volume")

call_district_plot

#Average response time by unit type
dispatch_by_unit <- aggregate(dispatch_time ~ unit_type, fire_dept, mean)
response_by_unit <- aggregate(response_time ~ unit_type, fire_dept, mean)
on_scene_by_unit <- aggregate(on_scene_time ~ unit_type,fire_dept, mean)
response_by_unit <- merge(dispatch_by_unit, response_by_unit, by = 'unit_type')
response_by_unit <- merge(response_by_unit, on_scene_by_unit, by = 'unit_type')
library(reshape2)
response.m <- melt(response_by_unit)
colnames(response.m) <- c('unit_type','time_interval','response_time')
unit_response_plot<-ggplot(data=response.m, aes(x=unit_type, y=response_time, fill = time_interval)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_fill_manual(values = c('#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Mean Response Time by Unit Type")+xlab("Type of Unit")+ylab("Mean Response Time (seconds)")

unit_response_plot

#Call volume by hour of the day
calls_hour <- aggregate(call_num ~ strftime(recd_timestamp,'%H', tz = 'PDT'), fire_dept, function(x){length(unique(x))})
colnames(calls_hour) <- c('hour_of_day', 'total_call_volume')
calls_by_hr_plot<-ggplot(data=calls_hour, aes(x=hour_of_day, y=total_call_volume)) +
  geom_bar(stat="identity", fill="steelblue")+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  ggtitle("Call Volume by Hour of the Day")+xlab("Hour of day (0-23)")+ylab("Total Call Volume")
calls_by_hr_plot
#Much lower during the early morning, as expected.

#Response Time by hour of the day
response_hour.1 <- aggregate(entry_time ~ strftime(recd_timestamp,'%H', tz = 'PDT'), fire_dept, mean)
colnames(response_hour.1) <- c('hour_of_day','entry_time')

response_hour.2 <- aggregate(dispatch_time ~ strftime(recd_timestamp,'%H', tz = 'PDT'), fire_dept, mean)
colnames(response_hour.2) <- c('hour_of_day','dispatch_time')

response_hour.3 <- aggregate(response_time ~ strftime(recd_timestamp,'%H', tz = 'PDT'), fire_dept, mean)
colnames(response_hour.3) <- c('hour_of_day','response_time')

response_hour.4 <- aggregate(on_scene_time ~ strftime(recd_timestamp,'%H', tz = 'PDT'), fire_dept, mean)
colnames(response_hour.4) <- c('hour_of_day','on_scene_time')

response_hour <- merge(response_hour.1, response_hour.2, by = 'hour_of_day')
response_hour <- merge(response_hour, response_hour.3, by = 'hour_of_day')
response_hour <- merge(response_hour, response_hour.4, by = 'hour_of_day')
response_hr.m <- melt(response_hour)

response_by_hr_plot<-ggplot(data=response_hr.m, aes(x=hour_of_day, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time", "Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Response time by Hour of the Day")+xlab("Hour of day (0-23)")+ylab("Mean Response Time (seconds)")

response_by_hr_plot
#Stays remarkably same throughout the day. Interesting.

#fire_dept <- fire_dept[!is.na(fire_dept$call_num),]
# Mean Response time by original priority
response_priority.1 <- aggregate(entry_time ~ original_priority, fire_dept, mean)
colnames(response_priority.1) <- c('priority','entry_time')

response_priority.2 <- aggregate(dispatch_time ~ original_priority, fire_dept, mean)
colnames(response_priority.2) <- c('priority','dispatch_time')

response_priority.3 <- aggregate(response_time ~ original_priority, fire_dept, mean)
colnames(response_priority.3) <- c('priority','response_time')

response_priority.4 <- aggregate(on_scene_time ~ original_priority, fire_dept, mean)
colnames(response_priority.4) <- c('priority','on_scene_time')

response_priority <- merge(response_priority.1, response_priority.2, by = 'priority')
response_priority <- merge(response_priority, response_priority.3, by = 'priority')
response_priority <- merge(response_priority, response_priority.4, by = 'priority')
response_priority.m <- melt(response_priority)

response_by_priority_plot<-ggplot(data=response_priority.m, aes(x=priority, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time", "Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Mean Response time by Call Priority")+xlab("Call Priority")+ylab("Mean Response Time (seconds)")

response_by_priority_plot
#Data Dictionary only defines 1,2,3 as order of increasing priority. That does shorten the response time-
#sharply. There's definite priority in unit assignment...

#Mean Response Time by Call Type Group (4 main: Fire, Alarm, Potentially Life-Threatening, Non Life-Threatening)
response_call_type.1 <- aggregate(entry_time ~ call_type, fire_dept, mean)
colnames(response_call_type.1) <- c('call_type','entry_time')

response_call_type.2 <- aggregate(dispatch_time ~ call_type, fire_dept, mean)
colnames(response_call_type.2) <- c('call_type','dispatch_time')

response_call_type.3 <- aggregate(response_time ~ call_type, fire_dept, mean)
colnames(response_call_type.3) <- c('call_type','response_time')

response_call_type.4 <- aggregate(on_scene_time ~ call_type, fire_dept, mean)
colnames(response_call_type.4) <- c('call_type','on_scene_time')

response_call_type <- merge(response_call_type.1, response_call_type.2, by = 'call_type')
response_call_type <- merge(response_call_type, response_call_type.3, by = 'call_type')
response_call_type <- merge(response_call_type, response_call_type.4, by = 'call_type')
response_call_type.m <- melt(response_call_type)

response_by_call_type_plot<-ggplot(data=response_call_type.m, aes(x=call_type, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time","Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Mean Response time by Call Type")+xlab("Call Type")+ylab("Mean Response Time (seconds)")

response_by_call_type_plot

#Response time by number of alarms
response_alarm.1 <- aggregate(entry_time ~ number_of_alarms, fire_dept, mean)
colnames(response_alarm.1) <- c('number_of_alarms','entry_time')

response_alarm.2 <- aggregate(dispatch_time ~ number_of_alarms, fire_dept, mean)
colnames(response_alarm.2) <- c('number_of_alarms','dispatch_time')

response_alarm.3 <- aggregate(response_time ~ number_of_alarms, fire_dept, mean)
colnames(response_alarm.3) <- c('number_of_alarms','response_time')

response_alarm.4 <- aggregate(on_scene_time ~ number_of_alarms, fire_dept, mean)
colnames(response_alarm.4) <- c('number_of_alarms','on_scene_time')

response_alarm <- merge(response_alarm.1, response_alarm.2, by = 'number_of_alarms')
response_alarm <- merge(response_alarm, response_alarm.3, by = 'number_of_alarms')
response_alarm <- merge(response_alarm, response_alarm.4, by = 'number_of_alarms')
response_alarm.m <- melt(response_alarm, id.vars = 'number_of_alarms')

response_by_number_of_alarms_plot<-ggplot(data=response_alarm.m, aes(x=number_of_alarms, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 30, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time","Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Mean Response time by Number of Alarms")+xlab("Number of Alarms")+ylab("Mean Response Time (seconds)")

response_by_number_of_alarms_plot

#Response time by fire prevention district
response_dist.1 <- aggregate(entry_time ~ fire_prevention_dist, fire_dept, mean)
colnames(response_dist.1) <- c('fire_prevention_dist','entry_time')

response_dist.2 <- aggregate(dispatch_time ~ fire_prevention_dist, fire_dept, mean)
colnames(response_dist.2) <- c('fire_prevention_dist','dispatch_time')

response_dist.3 <- aggregate(response_time ~ fire_prevention_dist, fire_dept, mean)
colnames(response_dist.3) <- c('fire_prevention_dist','response_time')

response_dist.4 <- aggregate(on_scene_time ~ fire_prevention_dist, fire_dept, mean)
colnames(response_dist.4) <- c('fire_prevention_dist','on_scene_time')

response_dist <- merge(response_dist.1, response_dist.2, by = 'fire_prevention_dist')
response_dist <- merge(response_dist, response_dist.3, by = 'fire_prevention_dist')
response_dist <- merge(response_dist, response_dist.4, by = 'fire_prevention_dist')
response_dist.m <- melt(response_dist)

response_by_fire_prevention_dist_plot<-ggplot(data=response_dist.m, aes(x=fire_prevention_dist, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 30, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time","Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Mean Response time by Fire Prevention District")+xlab("Fire prevention District")+ylab("Mean Response Time (seconds)")

response_by_fire_prevention_dist_plot


#write.csv(fire_dept,'/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_ads.csv')

#Download the weather data
# file <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"
# repeat 
# {
#   try(download.file(file, "/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/isd-history.csv", quiet = TRUE))
#   if (file.info("/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/isd-history.csv")$size >0) 
#   {
#     break
#   }
# }
# st <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/isd-history.csv')
# st$BEGIN <- as.numeric(substr(st$BEGIN, 1, 4))
# st$END <- as.numeric(substr(st$END, 1, 4))
# 
# ca.list.2 <- st[st$STATE == "CA"& (st$BEGIN <= 20130000 & st$END >= 20180601) & st$ICAO == 'KSFO',]
# dim(ca.list.2)
# 
# outputs <- as.data.frame(matrix(NA, dim(ca.list.2)[1], 2))
# names(outputs) <- c("FILE", "STATUS")
# 
# for (y in 2013:2018) 
# {
#   y.ca.list.2 <- ca.list.2[ca.list.2$BEGIN <= y & ca.list.2$END >= y, ]
#   for (s in 1:dim(y.ca.list.2)[1]) 
#   {
#     outputs[s, 1] <- paste(sprintf("%06d", y.ca.list.2[s, 1]), "-", sprintf("%05d", y.ca.list.2[s, 2]), "-", y, ".gz", sep = "")
#     wget <- paste("wget -P data/raw ftp://ftp.ncdc.noaa.gov/pub/data/noaa/", y, "/", outputs[s, 1], sep = "")
#     outputs[s, 2] <- try(system(wget, intern = FALSE, ignore.stderr = TRUE))
#   }
# }
# 
# files <- list.files("/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/Weather data/")
# column.widths <- c(4, 6, 5, 4, 2, 2, 2, 2, 1, 6,7, 5, 5, 5, 4, 3, 1, 1, 4, 1, 5, 1, 1, 1, 6,1, 1, 1, 5, 1, 5, 1, 5, 1)
# stations <- as.data.frame(matrix(NA, length(files), 6))
# names(stations) <- c("USAFID", "WBAN", "YR", "LAT", "LONG", "ELEV")
# for (i in 1:length(files)) 
# {
#   data <- read.fwf(paste("/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/Weather data/", files[i], sep = ""), column.widths)
#   data <- data[, c(2:8, 10:11, 13, 16, 19, 29, 31, 33)]
#   names(data) <- c("USAFID", "WBAN", "YR", "M","D", "HR", "MIN", "LAT", "LONG", "ELEV", "WIND.DIR", "WIND.SPD", "TEMP", "DEW.POINT", "ATM.PRES")
#   data$LAT <- data$LAT/1000
#   data$LONG <- data$LONG/1000
#   data$WIND.SPD <- data$WIND.SPD/10
#   data$TEMP <- data$TEMP/10
#   data$DEW.POINT <- data$DEW.POINT/10
#   data$ATM.PRES <- data$ATM.PRES/10
#   write.csv(data, file = paste("/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/Weather data/csv/", files[i], ".csv", sep = ""), row.names = FALSE)
#   stations[i, 1:3] <- data[1, 1:3]
#   stations[i, 4:6] <- data[1, 8:10]
# }

#I found hourly San Francisco weather data uploaded as a dataset on Kaggle, so I'll use that.
#Load the weather data
sf_weather_desc <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/sf_weather_description.csv', stringsAsFactors = FALSE)
sf_temp <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/sf_temperature.csv')
sf_wind_speed <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/sf_wind_speed.csv')
sf_weather_desc$datetime <- as.POSIXct(sf_weather_desc$datetime, tz = 'PDT')
colnames(sf_weather_desc) <- c('datetime','weather_description')
sf_temp$datetime <- as.POSIXct(sf_temp$datetime, tz = 'PDT')
colnames(sf_temp) <- c('datetime','temperature')
sf_wind_speed$datetime <- as.POSIXct(sf_wind_speed$datetime, tz = 'PDT')
colnames(sf_wind_speed) <- c('datetime','wind_speed')

sf_weather <- merge(sf_weather_desc, sf_temp, by = 'datetime')
sf_weather <- merge(sf_weather, sf_wind_speed, by = 'datetime')                    

#Need to make it in a format with date and hour of day separate
sf_weather$date <- strftime(sf_weather$datetime, '%F')
sf_weather$hour_of_day <- strftime(sf_weather$datetime, '%H')
sf_weather <- sf_weather[sf_weather$date >= '2013-06-01' & sf_weather$date <= '2017-10-27',]
#Check for NAs
sum(is.na(sf_weather$weather_description))  #0
sum(is.na(sf_weather$temperature))  #0
sum(is.na(sf_weather$wind_speed))   #1
sf_weather$wind_speed[is.na(sf_weather$wind_speed)] <- median(na.omit(sf_weather$wind_speed))


fire_dept$hour_of_day <- strftime(fire_dept$recd_timestamp,'%H')
fire_dept <- merge(fire_dept, sf_weather, by.x = c('call_date','hour_of_day'), by.y = c('date','hour_of_day'))

#How does response time vary by weather?
unique(fire_dept$weather_description)

response_weather.1 <- aggregate(entry_time ~ weather_description, fire_dept, mean)
colnames(response_weather.1) <- c('weather_description','entry_time')

response_weather.2 <- aggregate(dispatch_time ~ weather_description, fire_dept, mean)
colnames(response_weather.2) <- c('weather_description','dispatch_time')

response_weather.3 <- aggregate(response_time ~ weather_description, fire_dept, mean)
colnames(response_weather.3) <- c('weather_description','response_time')

response_weather.4 <- aggregate(on_scene_time ~ weather_description, fire_dept, mean)
colnames(response_weather.4) <- c('weather_description','on_scene_time')

response_weather <- merge(response_weather.1, response_weather.2, by = 'weather_description')
response_weather <- merge(response_weather, response_weather.3, by = 'weather_description')
response_weather <- merge(response_weather, response_weather.4, by = 'weather_description')
response_weather.m <- melt(response_weather)

response_by_weather_plot<-ggplot(data=response_weather.m, aes(x=weather_description, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time", "Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Response time by Weather")+xlab("Weather Description")+ylab("Mean Response Time (seconds)")

response_by_weather_plot

#Check out the performance of units
length(unique(fire_dept$unit_id))
response_time_by_unit <- aggregate(response_time ~ unit_id, fire_dept, mean)
on_scene_time_by_unit <- aggregate(on_scene_time ~ unit_id, fire_dept, mean)
response_time_by_unit <- merge(response_time_by_unit, on_scene_time_by_unit, by = 'unit_id')
response_by_unit.m <- melt(response_time_by_unit, 'unit_id')

response_by_unit_id_plot<-ggplot(data=response_by_unit.m[response_by_unit.m$value <= 4000,], aes(x=unit_id, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2'),name="Time Interval", labels=c("Response Time","On Scene Time"))+
  ggtitle("Response time by Unit")+xlab("Unit")+ylab("Mean Response Time (seconds)")
response_by_unit_id_plot

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
cor(na.omit(fire_dept$distance_from_station), fire_dept$on_scene_time[!is.na(fire_dept$distance_from_station)])
#Correlation is -0.012 for total response time, -0.005 for on_scene_time. Basically no correlation at all. Interesting.
cor(na.omit(fire_dept$temperature), fire_dept$total_response_time)

plot(x = fire_dept$number_of_alarms, y = fire_dept$total_response_time)

#Check which columns have NAs, because they will fuck with Caret.
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

fire_dept$fire_response_time <- -as.numeric(difftime(fire_dept$entry_timestamp, fire_dept$on_scene_timestamp, units = "secs"))

#Does response time vary by battalion?
response_bat.1 <- aggregate(entry_time ~ battalion, fire_dept, mean)
colnames(response_bat.1) <- c('battalion','entry_time')

response_bat.2 <- aggregate(dispatch_time ~ battalion, fire_dept, mean)
colnames(response_bat.2) <- c('battalion','dispatch_time')

response_bat.3 <- aggregate(response_time ~ battalion, fire_dept, mean)
colnames(response_bat.3) <- c('battalion','response_time')

response_bat.4 <- aggregate(on_scene_time ~ battalion, fire_dept, mean)
colnames(response_bat.4) <- c('battalion','on_scene_time')

response_bat <- merge(response_bat.1, response_bat.2, by = 'battalion')
response_bat <- merge(response_bat, response_bat.3, by = 'battalion')
response_bat <- merge(response_bat, response_bat.4, by = 'battalion')
response_bat.m <- melt(response_bat)

response_by_bat_plot<-ggplot(data=response_bat.m, aes(x=battalion, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time", "Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Response time by Battalion")+xlab("Battalion")+ylab("Mean Response Time (seconds)")

response_by_bat_plot

#ALS unit - Y/N
response_als.1 <- aggregate(entry_time ~ als_unit, fire_dept, mean)
colnames(response_als.1) <- c('als_unit','entry_time')

response_als.2 <- aggregate(dispatch_time ~ als_unit, fire_dept, mean)
colnames(response_als.2) <- c('als_unit','dispatch_time')

response_als.3 <- aggregate(response_time ~ als_unit, fire_dept, mean)
colnames(response_als.3) <- c('als_unit','response_time')

response_als.4 <- aggregate(on_scene_time ~ als_unit, fire_dept, mean)
colnames(response_als.4) <- c('als_unit','on_scene_time')

response_als <- merge(response_als.1, response_als.2, by = 'als_unit')
response_als <- merge(response_als, response_als.3, by = 'als_unit')
response_als <- merge(response_als, response_als.4, by = 'als_unit')
response_als.m <- melt(response_als)

response_by_als_plot<-ggplot(data=response_als.m, aes(x=als_unit, y=value, fill = variable)) +
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  scale_fill_manual(values = c('#b5cde1','#90b4d2','#6a9bc3','#4682b4'),name="Time Interval", labels=c("Entry Time", "Dispatch Time", "Response Time","On Scene Time"))+
  ggtitle("Response time by als_unit")+xlab("als_unit")+ylab("Mean Response Time (seconds)")

response_by_als_plot

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


#Divide into train and test
sample_size <- floor(0.6 * nrow(fire_dept))
set.seed(2014)
train_index <- sample(seq_len(nrow(fire_dept)), size = sample_size)
fire_train <- fire_dept[train_index,]
remain40 <- fire_dept[-train_index,]
test_valid_index <- sample(seq_len(nrow(remain40)), 0.5*nrow(remain40))
fire_validn <- remain40[test_valid_index,]
fire_test <- remain40[-test_valid_index,]
# fire_test <- fire_dept[-train_index,]

#Look at the distributions of each of the time intervals
plot(density(fire_dept$entry_time), xlim = c(0,400))
plot(density(fire_dept$dispatch_time), xlim = c(0,400))
plot(density(fire_dept$response_time), xlim = c(0,400))
plot(density(fire_dept$scene_time), xlim = c(0,600))

#Look at the distributions of each of the time intervals
entry_time_dist <- qplot(entry_time, data=fire_dept, geom="density") + xlim(0,400)+
                ggtitle("Frequency Distribution of Entry Time")+xlab("Entry Time (secs)")+ylab("Density")
entry_time_dist

dispatch_time_dist <- qplot(dispatch_time, data=fire_dept, geom="density") + xlim(0,300)+
                ggtitle("Frequency Distribution of Dispatch Time")+xlab("Dispatch Time (secs)")+ylab("Density")
dispatch_time_dist

response_time_dist <- qplot(response_time, data=fire_dept, geom="density") + xlim(0,300)+
  ggtitle("Frequency Distribution of Response Time")+xlab("Response Time (secs)")+ylab("Density")
response_time_dist

scene_time_dist <- qplot(on_scene_time, data=fire_dept, geom="density") + xlim(0,1000)+
  ggtitle("Frequency Distribution of Time taken to reach scene")+xlab("On-scene Time (secs)")+ylab("Density")
scene_time_dist

summary_time <- data.frame(cbind('Entry Time',mean(fire_dept$entry_time), sd(fire_dept$entry_time)))
summary_time <- rbind(summary_time, data.frame(cbind('Dispatch Time',mean(fire_dept$dispatch_time), sd(fire_dept$dispatch_time))))
summary_time <- rbind(summary_time, data.frame(cbind('Response Time',mean(fire_dept$response_time), sd(fire_dept$response_time))))
summary_time <- rbind(summary_time, data.frame(cbind('On Scene Time',mean(fire_dept$on_scene_time), sd(fire_dept$on_scene_time))))
colnames(summary_time) <- c('Time Interval', 'Mean', 'Standard Dev.')

library(caret)
# define training control
train_control<- trainControl(method="cv", number=3, savePred=TRUE)

#LM model
response_time_lm <- lm(total_response_time ~ station_area+ hour_of_day+ call_type+
                         #zipcode+
                         original_priority+ weather_description+temperature+
                         wind_speed+distance_from_station, fire_train)

summary(response_time_lm)

write.csv(fire_train,'/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_train.csv')
write.csv(fire_validn,'/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_validn.csv')
write.csv(fire_test,'/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_test.csv')

# response_time_predict <- train(total_response_time ~ as.factor(station_area)+as.factor(hour_of_day)+
#                                  as.factor(call_type)+as.factor(zipcode)+as.factor(original_priority)+
#                                  as.factor(number_of_alarms)+as.factor(unit_type)+
#                                  as.factor(fire_prevention_dist)+as.factor(neighbourhood_dist)+
#                                  as.factor(weather_description)+temperature+wind_speed+distance_from_station,
#                                fire_train, method = "lm", na.action = na.omit)
# summary(response_time_predict)

# fire_train <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_train.csv')
# fire_validn <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_validn.csv')
# fire_test <- read.csv('/home/ab/Downloads/Datasets for analysis/Fire Department Service Calls/fire_test.csv')

#Predict using decision tree
library(rpart)
dtree_fit_1 <- rpart(total_response_time ~ station_area+ hour_of_day+ call_type+
                       original_priority+ weather_description+temperature+
                       wind_speed+distance_from_station, fire_train)

dtree_2 <- rpart(total_response_time ~ hour_of_day+call_type+weather_description, fire_train)
summary(dtree_2)
# dtree_fit <- train(total_response_time ~ station_area+ hour_of_day+ call_type+
#                    original_priority+ weather_description+temperature+
#                    wind_speed+distance_from_station, fire_train, trControl = train_control, method = "rpart")

summary(dtree_fit_1)
fire_validn$predicted_response_time <- predict(dtree_fit_1,fire_validn)
#fire_validn$predicted_response_time <- mean(fire_validn$total_response_time)
rmse <- function(actual, predicted){
  sqrt(mean((actual - predicted)^2))
}
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)
#RMSE with simple mean prediction is 386.37 - Baseline
#RMSE with dtree_2: 375.85
#RMSE with dtree_1: 336.47 sec
summary(fire_dept$total_response_time)
sd(fire_dept$total_response_time)
#For the response time, mu is 505 and sigma is 383.THAT is how much variation there is in the data.

dtree_4 <- rpart(total_response_time ~ station_area+hour_of_day+call_type+battalion+als_unit+
                   original_priority+weather_description+temperature+final_priority+unit_type+
                   wind_speed+distance_from_station+number_of_alarms, fire_train)

fire_validn$predicted_response_time <- predict(dtree_4,fire_validn)
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)
library(randomForest)
set.seed(3)
dtree_5 <- randomForest(total_response_time ~ hour_of_day+call_type+battalion+als_unit+
                         weather_description+temperature+final_priority+unit_type+
                          wind_speed+distance_from_station+number_of_alarms, fire_train,
                        ntree = 100, importance = TRUE)
fire_validn$predicted_response_time <- predict(dtree_5,fire_validn)
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)

#I'm gonna check out all the rows with response time = 0. Are they fucking up the variance?
sum(fire_dept$total_response_time == 0) #10393 rows
mean_wo_zero <- mean(fire_dept$total_response_time[fire_dept$total_response_time != 0])
sd_wo_zero <- sd(fire_dept$total_response_time[fire_dept$total_response_time != 0])
fire_dept$zero_time_flag <- 0
fire_dept$zero_time_flag[fire_dept$total_response_time == 0] <- 1
fire_dept$zero_time_flag <- as.factor(fire_dept$zero_time_flag)

dtree_6 <- rpart(total_response_time ~ station_area+hour_of_day+call_type+battalion+als_unit+
                   original_priority+weather_description+temperature+final_priority+unit_type+
                   wind_speed+distance_from_station+number_of_alarms+zero_time_flag, fire_train)

fire_validn$predicted_response_time <- predict(dtree_6,fire_validn)
fire_validn_err <- rmse(fire_validn$total_response_time, fire_validn$predicted_response_time)

fire_train$zero_time_flag <- NULL
fire_validn$zero_time_flag <- NULL
fire_test$zero_time_flag <- NULL
#I'm gonna try PCA, maybe that'll help
#First, convert the categoricals to dummy variables
library(caret)
fire_train_dmy <- dummyVars(" ~ station_area+hour_of_day+call_type+battalion+als_unit+
                   original_priority+weather_description+final_priority+unit_type", data = fire_train_3)
fire_train_dmy2 <- data.frame(predict(fire_train_dmy, newdata = fire_train))

library(factoextra)
fire_train_pca <- prcomp(fire_train_dmy2, scale = TRUE)
fviz_eig(fire_train_pca)

library(mgcv)
knots <- quantile(fire_train$temperature, p = c(0.25,0.5,0.75))
spline_model <- gam(total_response_time ~ s(hour_of_day)+s(call_type)+s(battalion)+s(als_unit)+
                s(original_priority)+s(weather_description)+s(temperature)+s(final_priority)+s(unit_type)+
                s(wind_speed)+s(distance_from_station)+s(number_of_alarms), data = fire_train)

#write.csv(fire_dept, '~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept.csv')

max(fire_dept$call_date)
min(fire_dept$call_date)
fire_dept_3 <- fire_dept[fire_dept$call_date <= '2016-05-31',]
fire_dept_2 <- fire_dept[fire_dept$call_date <= '2015-09-31',]

#write.csv(fire_dept_3, '~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_3.csv')
sample_size_3 <- floor(0.6 * nrow(fire_dept_2))
set.seed(2014)
train_index_3 <- sample(seq_len(nrow(fire_dept_2)), size = sample_size_3)
fire_train_3 <- fire_dept_2[train_index_3,]
remain403 <- fire_dept_2[-train_index_3,]
test_valid_index_3 <- sample(seq_len(nrow(remain403)), 0.5*nrow(remain403))
fire_validn_3 <- remain403[test_valid_index_3,]
fire_test_3 <- remain403[-test_valid_index_3,]

sd(fire_validn_3$total_response_time) #399seconds

library(rpart)
dtree_63 <- rpart(total_response_time ~ station_area+hour_of_day+call_type+battalion+als_unit+
                   original_priority+weather_description+temperature+final_priority+unit_type+
                   wind_speed+distance_from_station+number_of_alarms+zero_time_flag, fire_train_3)

fire_validn_3$predicted_response_time <- predict(dtree_63,fire_validn_3)
fire_validn_err3 <- rmse(fire_validn_3$total_response_time, fire_validn_3$predicted_response_time)
#RMSE is now 314.56. Cool.

write.csv(fire_dept_2,'~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_dept_2.csv', row.names = F)
rm(list = ls())
saveRDS(fire_train_3,'~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_train_3.Rda')
saveRDS(fire_validn_3,'~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_validn_3.Rda')
saveRDS(fire_test_3, '~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_test_3.Rda')

fire_train_3 <- readRDS('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_train_3.Rda')
fire_validn_3 <- readRDS('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_validn_3.Rda')
fire_test_3 <- readRDS('~/Downloads/Datasets for analysis/Fire Department Service Calls/fire_test_3.Rda')

library(randomForest)
set.seed(3)
dtree_53 <- randomForest(total_response_time ~ hour_of_day+call_type+battalion+als_unit+
                          weather_description+temperature+final_priority+unit_type+
                          wind_speed+distance_from_station+number_of_alarms, fire_train_3,
                        ntree = 300, na.action = na.omit, importance = TRUE)
fire_validn_3$predicted_response_time <- predict(dtree_53,fire_validn_3)
fire_validn_err_3 <- rmse(fire_validn_3$total_response_time, fire_validn_3$predicted_response_time)
print(fire_validn_err_3)