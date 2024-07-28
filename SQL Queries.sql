-- Creating Table 'Daily_Activity'
CREATE TABLE Daily_Activity (
    Id VARCHAR(50),
    ActivityDate DATE,
    TotalSteps INT,
    TotalDistance DOUBLE PRECISION,
    TrackerDistance DOUBLE PRECISION,
    LoggedActivitiesDistance DOUBLE PRECISION,
    VeryActiveDistance DOUBLE PRECISION,
    ModeratelyActiveDistance DOUBLE PRECISION,
    LightActiveDistance DOUBLE PRECISION,
    SedentaryActiveDistance DOUBLE PRECISION,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories INT,
	Day VARCHAR(50)
);

-- Creating Table 'Sleep'
CREATE TABLE Sleep (
    Id VARCHAR(50),
    SleepDay DATE,
    TotalSleepRecords INT,
    TotalMinutesAsleep DOUBLE PRECISION,
    TotalTimeInBed DOUBLE PRECISION,
    LoggedActivitiesDistance DOUBLE PRECISION,
    VeryActiveDistance DOUBLE PRECISION,
    ModeratelyActiveDistance DOUBLE PRECISION,
    LightActiveDistance DOUBLE PRECISION,
    SedentaryActiveDistance DOUBLE PRECISION,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories INT,
	Day VARCHAR(50)
);

-- Creating Table 'MET'
CREATE TABLE MET (
	Id VARCHAR(50),
    ActivityDate DATE,
    METs INT
);

-- Viewing data from each table
SELECT * FROM Daily_Activity;
SELECT * FROM Sleep;
SELECT * FROM MET;

-- Checking users insigths
/* 
    This SQL code is calculating the distribution of users based on the number of times they have used the fitness tracker.
    It counts how many users fall into each frequency category and calculates the percentage of users for each category out of
    the total of 33 users. The results are sorted in descending order of usage frequency, providing insights into user engagement
    with the fitness tracker.
*/

SELECT 
    COUNT(NumberTimesUse) AS Users,
    ROUND((COUNT(NumberTimesUse) / 33.0) * 100, 2) AS PrecentageOfUsers,
    NumberTimesUse
FROM
    (SELECT 
        Id, COUNT(Id) AS NumberTimesUse
    FROM
        Daily_Activity
    GROUP BY Id) AS UsersImplication
GROUP BY NumberTimesUse
ORDER BY NumberTimesUse DESC;

-- Checking usage range
/*
   This SQL code categorizes users based on their engagement with the fitness tracker.
   It calculates the usage frequency for each user, categorizes them as 'Active User,' 
   'Moderate User,' or 'Light User' based on predefined ranges, and then counts how many 
   users fall into each category. The results are ordered by the number of users in each 
   category, providing insights into the distribution of user engagement levels with the tracker.
*/
SELECT 
    TrackerUsage, COUNT(TrackerUsage) AS Users
FROM
    (SELECT 
        Id,
            COUNT(Id) AS NumberTimesUse,
            CASE
                WHEN COUNT(Id) BETWEEN 25 AND 31 THEN 'Active User'
                WHEN COUNT(Id) BETWEEN 15 AND 24 THEN 'Moderate User'
                WHEN COUNT(Id) BETWEEN 0 AND 14 THEN 'Light User'
            END TrackerUsage
    FROM
        Daily_Activity
    GROUP BY Id) AS Ranges
GROUP BY TrackerUsage
ORDER BY Users;

-- Calculate Average
SELECT 
    AVG(TotalSteps) AS AVG_TotalSteps
FROM
    Daily_Activity;

-- Calculate total distance average 
SELECT 
    AVG(TotalDistance) AS AVG_TotalDistance
FROM
    Daily_Activity;

-- Calculate No. of People with Steps>10000 and <1000 (Recommended)
/*
   This SQL code categorizes users based on their average daily step count. It calculates the average steps for each user,
   categorizes them as '10000 or more' or 'less than 10000' based on whether their average steps are equal to or greater
   than 10,000, and then counts how many users fall into each category. The results provide insights into the distribution
   of users meeting the recommended daily step count of 10,000 or more.
*/
SELECT 
    CompleteStepsRecommendation,
    COUNT(CompleteStepsRecommendation) AS UsersNumber
FROM
    (SELECT 
        Id,
            AVG(TotalSteps) AS AvgTotalSteps,
            CASE
                WHEN AVG(TotalSteps) >= 10000 THEN '10000 or more'
                WHEN AVG(TotalSteps) < 10000 THEN 'less than 10000'
            END CompleteStepsRecommendation
    FROM
        Daily_Activity
    GROUP BY Id) AS Steps
GROUP BY CompleteStepsRecommendation;

-- Calculate (Tracker Active during Sleep)
/*
   This SQL code calculates the percentage of users who use their tracker during sleep and those who don't.
   It first counts the number of distinct users who have sleep data (SleepUsers) and subtracts this from the
   total number of users (33 in this case) to calculate the number of users who don't use their tracker during
   sleep (NonSleepUsers). It then calculates the percentages of SleepUsers and NonSleepUsers out of the total
   user base (33 users) and rounds the percentages to two decimal places.
*/
SELECT 
    ROUND((SleepUsers / 33.0) * 100, 2) AS PercentageSleepUsers,
    ROUND((NonSleepUsers / 33.0) * 100, 2) AS PercentageNonSleepUsers
FROM
    (SELECT 
        COUNT(DISTINCT Id) AS SleepUsers,
            33 - COUNT(DISTINCT ID) AS NonSleepUsers
    FROM
        Sleep) AS SleepUse;
	
-- Sleep Quality
/*
This SQL code calculates the percentage of users based on their sleep quality. It first calculates the sleep
quality for each user based on the average total minutes asleep (TotalMinutesAsleep). Sleep quality is categorized
as 'Poor Sleep' for users with less than 360 minutes of sleep, 'Good Sleep' for users with 360 to 479 minutes of
sleep, and 'Excellent Sleep' for users with 480 or more minutes of sleep.

The inner query calculates sleep quality for each user and groups the results by user ID. The outer query then
calculates the percentage of users in each sleep quality category out of a total of 24 hours (assuming a full day)
and rounds the percentages to two decimal places. The results are ordered by sleep quality categories.
*/
SELECT 
    SleepQuality,
    ROUND((COUNT(*) / 24.0) * 100, 2) AS PercentageSleepQuality
FROM (
    SELECT 
        Id,
        CASE
            WHEN AVG(TotalMinutesAsleep) < 360 THEN 'Poor Sleep'
            WHEN AVG(TotalMinutesAsleep) >= 360 AND AVG(TotalMinutesAsleep) < 480 THEN 'Good Sleep'
            WHEN AVG(TotalMinutesAsleep) >= 480 THEN 'Excellent Sleep'
        END AS SleepQuality
    FROM
        Sleep
    GROUP BY Id
) AS SleepRange
GROUP BY SleepQuality
ORDER BY SleepQuality;

-- Average Calories
SELECT 
    AVG(Calories) AS AVG_Calories
FROM
    Daily_Activity;


-- Calculate (Average - Sedentary Hours Per Day)
SELECT 
    AVG(SedentaryMinutes) / 60 AS AVG_SedentaryHours
FROM
    Daily_Activity;

-- Calculate (Average - Lightly Active Hours Per Day)
SELECT 
    AVG(LightlyActiveMinutes) / 60 AS AVG_LightlyActiveHours
FROM
    Daily_Activity;

-- Calculate (Average - Fairly Active Minutes Per Day)
SELECT 
    AVG(FairlyActiveMinutes) AS AVG_FairlyActiveMinutes
FROM
    Daily_Activity;

-- Calculate (Average - Very Active Minutes Per Day)
SELECT 
    AVG(VeryActiveMinutes) AS AVG_VeryActiveMinutes
FROM
    Daily_Activity;


-- Correlation
SELECT 
    a.Id,
    AVG(a.TotalSteps) AS AvgTotalSteps,
    AVG(a.VeryActiveMinutes) AS AvgVeryActiveMinutes,
    AVG(a.FairlyActiveMinutes) AS AvgFairlyActiveMinutes,
    AVG(a.LightlyActiveMinutes) AS AvgLightlyActiveMinutes,
    AVG(a.SedentaryMinutes) AS AvgSedentaryMinutes,
    AVG(a.Calories) AS AvgCalories,
    AVG(s.TotalMinutesAsleep) AS AvgTotalMinutesAsleep
FROM
    Daily_Activity AS a
        INNER JOIN
    Sleep AS s ON a.Id = s.Id
GROUP BY a.Id
ORDER BY AvgCalories DESC;

-- Comparison (Activities & Calories)
Select Id,
SUM(TotalSteps) as total_steps,
SUM(VeryActiveMinutes) as total_very_active_mins,
Sum(FairlyActiveMinutes) as total_fairly_active_mins,
SUM(LightlyActiveMinutes) as total_lightly_active_mins,
SUM(Calories) as total_calories
From Daily_Activity
Group By Id

-- Comparison (Sleep & Calories)
Select temp1.Id, SUM(TotalMinutesAsleep) as total_sleep_min,
SUM(TotalTimeInBed) as total_time_inbed_min,
SUM(Calories) as calories
From Daily_Activity as temp1
Inner Join Sleep as temp2
ON temp1.Id = temp2.Id and temp1.ActivityDate = temp2.SleepDay
Group By temp1.Id

-- Average MET per day per use and Comparison with the calories burned
/*
    This SQL code performs an inner join between two tables: 'MET' (aliased as 'temp1') and 'Daily_Activity' (aliased as 'temp2').
    It retrieves distinct records based on the user ID (temp1.Id), activity date (temp1.ActivityDate), and calculates the
    sum of METs (Metabolic Equivalent of Task) as 'sum_mets' and the corresponding calories burned (temp2.Calories). The
    results are grouped by user ID, activity date, and calories. The OFFSET and FETCH FIRST clauses limit the result
    set to the first 10 rows ordered by activity date.
*/
Select Distinct temp1.Id, temp1.ActivityDate, sum(temp1.METs) as sum_mets, temp2.Calories
From MET as temp1
inner join Daily_Activity as temp2
on temp1.Id = temp2.Id and temp1.ActivityDate = temp2.ActivityDate
Group By temp1.Id, temp1.ActivityDate, temp2.Calories
Order by ActivityDate
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY
