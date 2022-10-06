---
title: "Case_study_note"
author: "Osazemen Eric Ogbeide"
date: "2022-10-01"
output: html_document
---
## About project
Use knowledge from Google Data Analytics courses to answer business question:a high-tech company, Bellabeat, that manufactures health-focused smart products wants to analyze smart device usage data in order to gain insight into how consumers are already using their smart devices.

## 1) Ask
### Keystakeholder:
Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer

Sando Mur: Mathematician and Bellabeat’s cofounder

Bellabeat marketing analytics team.

### Business task:
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

## 2) Prepare
The data is public data from FitBit Fitness Tracker Data <https://www.kaggle.com/arashnic/fitbit>. It's a dataset from thirty fitbit users that includes minute-level output for physical activity, heart rate, and sleep monitoring. It's a good database segmented in several tables with different aspects of the data of the device with lots of details about the user behaviour.

### Load packages needed
```{r}
library(tidyverse)
library(dplyr)
```
### Load CSV files into seperate dataframe
```{r}
daily_activity <- read.csv("dailyActivity_merged.csv")
daily_calories <- read.csv("dailyCalories_merged.csv")
daily_intensities <- read.csv("dailyIntensities_merged.csv")
daily_steps <- read.csv("dailySteps_merged.csv")
sleep_day <- read.csv("sleepDay_merged.csv")
```

## 3) Process and Analyze
### Verify the data structure
```{r}
str(daily_activity)
str(daily_calories)
str(daily_intensities)
str(daily_steps)
str(sleep_day)
```
### Verify the column names of each dataftrame
```{r}
colnames(daily_activity)
colnames(daily_calories)
colnames(daily_intensities)
colnames(daily_steps)
colnames(sleep_day)
```
### Summary: some initial findings
a)The dataframe 'daily_calories', 'daily_intensities', and 'daily_steps', all have duplicate datasets which are contained in the 'daily_activvity' dataframe.

b)The 'sleep_day' dataframe only has the 'Id' column as the duplicate dataset.

### Use the 'head()' function to see few lines in each dataframes
```{r}
head(daily_activity)
head(daily_calories)
head(daily_intensities)
head(daily_steps)
head(sleep_day)
```
### Check number of distinct users in each dataframe
```{r}
n_distinct(daily_activity$Id)
n_distinct(sleep_day$Id)
n_distinct(daily_steps$Id)
n_distinct(daily_calories$Id)
n_distinct(daily_intensities$Id)
```
### Number of rows in each dataset
```{r}
nrow(daily_activity)
nrow(sleep_day)
nrow(daily_steps)
nrow(daily_calories)
nrow(daily_intensities)
```
## Data Cleaning
Perform some data cleaning by select and summarizing the necessary data. And then eliminating the duplicate dataset.
```{r}
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

```
### Merge and assign datasets to a new dataframe 'daily_data'
```{r}
data_1 <- merge(daily_activity, daily_calories, c("Id", "Calories"))%>%
  select(Id,Calories,ActivityDate,TotalSteps,SedentaryMinutes,VeryActiveMinutes,LightlyActiveMinutes)

daily_data <- merge(data_1, sleep_day, by="Id", all=TRUE)%>%
  select(-TotalSleepRecords,-SleepDay)%>%
  drop_na()
```

### Verify the structure of the new dataframe
```{r}
str(daily_data)
head(daily_data)
tail(daily_data)
```
## Share findings
```{r}
ggplot(data=daily_data, aes(x=SedentaryMinutes, y=Calories)) + geom_point()
ggplot(data=daily_data, aes(x=VeryActiveMinutes, y=Calories))+geom_point()
ggplot(data=daily_data, aes(x=LightlyActiveMinutes, y=Calories))+geom_point()
```
