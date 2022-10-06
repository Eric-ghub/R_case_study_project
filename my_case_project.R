#Install and load packages

install.packages("tidyverse")
install.packages("dplyr")
install.packages("lubridate")
library(tidyverse)
library(dplyr)
library(lubridate)

#load CSV files into seperate dataframe 

daily_activity <- read.csv("dailyActivity_merged.csv")
daily_calories <- read.csv("dailyCalories_merged.csv")
daily_intensities <- read.csv("dailyIntensities_merged.csv")
daily_steps <- read.csv("dailySteps_merged.csv")
sleep_day <- read.csv("sleepDay_merged.csv")

#Verify structure of each data frame

str(daily_activity)
str(daily_calories)
str(daily_intensities)
str(daily_steps)
str(sleep_day)

#Verify column names of our dataframe

colnames(daily_activity)
colnames(daily_calories)
colnames(daily_intensities)
colnames(daily_steps)
colnames(sleep_day)

head(daily_activity)
head(daily_calories)
head(daily_intensities)
head(daily_steps)
head(sleep_day)

#change date format

daily_activity$ActivityDate <- mdy(daily_activity$ActivityDate)
daily_calories$ActivityDay <- mdy(daily_calories$ActivityDay)
daily_intensities$ActivityDay <- mdy(daily_intensities$ActivityDay)
daily_steps$ActivityDay <- mdy(daily_steps$ActivityDay)

#check number of distinct values in each datafrme

n_distinct(daily_activity$Id)
n_distinct(sleep_day$Id)
n_distinct(daily_steps$Id)
n_distinct(daily_calories$Id)
n_distinct(daily_intensities$Id)

#Verify number of rows in each dataframe

nrow(daily_activity)
nrow(sleep_day)
nrow(daily_steps)
nrow(daily_calories)
nrow(daily_intensities)

#View the summary of each dataframe

daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes) %>%
  summary()

sleep_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()

daily_steps %>%
  select(StepTotal) %>%
  summary()

daily_calories %>%
  select(Calories) %>%
  summary()

#Merge dataset and create a new dataframe

data_1 <- merge(daily_activity, daily_calories, c("Id", "Calories"))%>%
  select(Id,Calories,ActivityDate,TotalSteps,SedentaryMinutes,VeryActiveMinutes,LightlyActiveMinutes)

daily_data <- merge(data_1, sleep_day, by="Id", all=TRUE)%>%
  select(-TotalSleepRecords,-SleepDay)%>%
  drop_na()

#Verify new dataframe

summary(daily_data)
nrow(daily_data)
n_distinct(daily_data)
View(daily_data)

#Plot to see correlation between different activities and calories burn

ggplot(data=daily_data, aes(x=SedentaryMinutes, y=Calories)) + geom_point()
ggplot(data=daily_data, aes(x=VeryActiveMinutes, y=Calories))+geom_point()
ggplot(data=daily_data, aes(x=LightlyActiveMinutes, y=Calories))+geom_point()


write.csv(daily_data, file = "daily_data.csv")