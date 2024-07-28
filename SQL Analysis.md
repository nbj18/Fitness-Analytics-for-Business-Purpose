
## Creating Table 'Daily Activity', 'Sleep' and 'MET'
````sql
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
````
## Viewing Table content
````sql
SELECT * FROM Daily_Activity;
SELECT * FROM Sleep;
SELECT * FROM MET;
````

## Counting Users by Activity Frequency 
This SQL code is calculating the distribution of users based on the number of times they have used the fitness tracker.
It counts how many users fall into each frequency category and calculates the percentage of users for each category out of
the total of 33 users. The results are sorted in descending order of usage frequency, providing insights into user engagement
with the fitness tracker.
````sql
-- Checking users insigths
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
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/79ac745a0bd1b3d3f5aa5e842543089e7d3fabf1/SQL%20Visualisations/Counting%20Users%20by%20Activity%20Frequency.png)
## Categorizing Users by Tracker Usage
This SQL code categorizes users based on their engagement with the fitness tracker.
It calculates the usage frequency for each user, categorizes them as 'Active User,' 
'Moderate User,' or 'Light User' based on predefined ranges, and then counts how many 
users fall into each category. The results are ordered by the number of users in each 
category, providing insights into the distribution of user engagement levels with the tracker.
````sql
-- Checking usage range
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
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/01a5b1caacc02d51a513433426a759ad841b0e3c/SQL%20Visualisations/Categorizing%20Users%20by%20Tracker%20Usage.png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/01a5b1caacc02d51a513433426a759ad841b0e3c/SQL%20Visualisations/Categorizing%20Users%20by%20Tracker%20Usage%20(Plot).png)
## Calculating Average Total Steps
````sql
-- Calculating Average Steps
SELECT 
    AVG(TotalSteps) AS AVG_TotalSteps
FROM
    Daily_Activity;
````
Average Total Steps : 7637.91
## Calculating Average Total Distance
````sql
-- Calculating Total Average Distance 
SELECT 
    AVG(TotalDistance) AS AVG_TotalDistance
FROM
    Daily_Activity;
````
Average Total Distance : 5.48
## Categorizing Users by Steps Recommendation
This SQL code categorizes users based on their average daily step count. It calculates the average steps for each user,
categorizes them as '10000 or more' or 'less than 10000' based on whether their average steps are equal to or greater
than 10,000, and then counts how many users fall into each category. The results provide insights into the distribution
of users meeting the recommended daily step count of 10,000 or more.
````sql
-- Calculate No. of People with Steps>10000 and <1000 (Recommended)
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
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/572c5838a01ee03db5cab60b0127fbf4c756cf7c/SQL%20Visualisations/Categorizing%20Users%20by%20Steps%20Recommendation.png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/572c5838a01ee03db5cab60b0127fbf4c756cf7c/SQL%20Visualisations/Categorizing%20Users%20by%20Steps%20Recommendation%20(Plot).png)
## Calculating Percentage of Sleep Users
This SQL code calculates the percentage of users who use their tracker during sleep and those who don't.
It first counts the number of distinct users who have sleep data (SleepUsers) and subtracts this from the
total number of users (33 in this case) to calculate the number of users who don't use their tracker during
sleep (NonSleepUsers). It then calculates the percentages of SleepUsers and NonSleepUsers out of the total
user base (33 users) and rounds the percentages to two decimal places.

````sql
-- Calculate (Tracker Active during Sleep)
SELECT 
    ROUND((SleepUsers / 33.0) * 100, 2) AS PercentageSleepUsers,
    ROUND((NonSleepUsers / 33.0) * 100, 2) AS PercentageNonSleepUsers
FROM
    (SELECT 
        COUNT(DISTINCT Id) AS SleepUsers,
            33 - COUNT(DISTINCT ID) AS NonSleepUsers
    FROM
        Sleep) AS SleepUse;
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/711a3063dd78132e76b9abf039a56c199fa44a80/SQL%20Visualisations/Calculating%20Percentage%20of%20Sleep%20Users.png)
## Categorizing Users by Sleep Quality

Subsequently, I examined the duration of sleep recorded by the users. I referenced the sleep expert guidelines,
categorizing sleep durations of less than 6 hours as 'Inadequate Sleep,' durations exceeding 6 hours but less than
8 hours as 'Adequate Sleep,' and 8 hours or more as 'Optimal Sleep.'

This SQL code calculates the percentage of users based on their sleep quality. It first calculates the sleep
quality for each user based on the average total minutes asleep (TotalMinutesAsleep). Sleep quality is categorized
as 'Poor Sleep' for users with less than 360 minutes of sleep, 'Good Sleep' for users with 360 to 479 minutes of
sleep, and 'Excellent Sleep' for users with 480 or more minutes of sleep.

The inner query calculates sleep quality for each user and groups the results by user ID. The outer query then
calculates the percentage of users in each sleep quality category out of a total of 24 hours (assuming a full day)
and rounds the percentages to two decimal places. The results are ordered by sleep quality categories.
````sql
-- Sleep Quality	
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
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/c6321ccba21e493c7158e36877ef6905330b7b7f/SQL%20Visualisations/Categorizing%20Users%20by%20Sleep%20Quality.png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/c6321ccba21e493c7158e36877ef6905330b7b7f/SQL%20Visualisations/Categorizing%20Users%20by%20Sleep%20Quality%20(Plot).png)


## Calculating Average Metrics and Correlation
````sql
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
````
**Results:** \
**Avergae Calories** - 2303.60 \
**Average Sedentary Hours (per day)** - 16.52017730 \
**Average Lightly Active Hours (per day)** - 3.21354610 \
**Average Fairly Active Minutes (per day)** - 13.5649 \
**Average Very Active Minutes (per day)** - 21.1649

## Correlation
````sql
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
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/98ac495e2c3ba4965a482a9390fa52a909ce9bd7/SQL%20Visualisations/Correlation%20(Plot).png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/f11bb027909708387a68bec907e121ddf0b82474/SQL%20Visualisations/Correlation%20Matrix.png)
**What does the Pearson Correlation Coefficient (r) indicate?**
 - The average of total minutes asleep shows a moderate negative correlation with the average of sedentary minutes.
 - There is no correlation between the average of calories and the average of sedentary minutes.
 - The average of very active minutes exhibits a strong positive correlation with the average of total steps.
 - The average of total minutes asleep demonstrates a weak negative correlation with the average of total steps.
 - The average of calories displays a moderate positive correlation with the average of total steps.
## Comparison (Activities & Calories)
````sql
-- Comparison (Activities & Calories)
Select Id,
SUM(TotalSteps) as total_steps,
SUM(VeryActiveMinutes) as total_very_active_mins,
Sum(FairlyActiveMinutes) as total_fairly_active_mins,
SUM(LightlyActiveMinutes) as total_lightly_active_mins,
SUM(Calories) as total_calories
From Daily_Activity
Group By Id
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/4d6e61dbc19aedf0ea8f877c2af08aa3a04f194f/SQL%20Visualisations/Comparison%20(Activities%20%26%20Calories).png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/c1bd92294daedf8bbf7b960d549d90d1ffee95b8/SQL%20Visualisations/Comparison%20(Activities%20%26%20Calories%20-%20Plot).png)
**Key Findings:**
- The R-Squared value for the Low Active graph is 0.0118.
- The R-Squared value for the Fairly Active graph is 0.0391.
- The R-Squared value for the Very Active graph is 0.3865.
- There exists a robust correlation between Very Active minutes and the calorie expenditure. The R-Squared value appears to increase with higher activity intensity and duration. In summary, as indicated by the R-Squared values of the respective trend lines, greater activity intensity and duration result in a higher calorie burn.
  
## Comparison (Sleep & Calories)
````sql
-- Comparison (Sleep & Calories)
Select temp1.Id, SUM(TotalMinutesAsleep) as total_sleep_min,
SUM(TotalTimeInBed) as total_time_inbed_min,
SUM(Calories) as calories
From Daily_Activity as temp1
Inner Join Sleep as temp2
ON temp1.Id = temp2.Id and temp1.ActivityDate = temp2.SleepDay
Group By temp1.Id
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/0da67b595721bb22bdd9f0cff31b8ede80a7f927/SQL%20Visualisations/Comparison%20(Sleep%20%26%20Calories).png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/0da67b595721bb22bdd9f0cff31b8ede80a7f927/SQL%20Visualisations/Comparison%20(Sleep%20%26%20Calories%20-Plot).png)
**Key Findings:**
- The R-Squared value stands at 0.8727.
- A substantial positive correlation is evident between the duration of sleep and calorie expenditure.
- Increased sleep duration correlates with higher calorie burn. Optimal sleep duration and quality contribute to increased calorie expenditure during sleep. However, exceeding the recommended range does not result in additional calorie burn; instead, it leads to a reduction in calories burned.

## Comparison of Average MET and Calories Burned Over Time
This SQL code performs an inner join between two tables: 'MET' (aliased as 'temp1') and 'Daily_Activity' (aliased as 'temp2').
It retrieves distinct records based on the user ID (temp1.Id), activity date (temp1.ActivityDate), and calculates the
sum of METs (Metabolic Equivalent of Task) as 'sum_mets' and the corresponding calories burned (temp2.Calories). The
results are grouped by user ID, activity date, and calories. The OFFSET and FETCH FIRST clauses limit the result
set to the first 10 rows ordered by activity date.

**Metabolic Equivalent of Task (MET)**
The metabolic equivalent of task (MET) is the objective measure of the ratio of the rate at which a person expends energy, relative to the mass of that person, while performing some specific physical activity compared to a reference, set by convention at 3.5 mL of oxygen per kilogram per minute, which is roughly equivalent to the energy expended when sitting quietly. MET: The ratio of the work metabolic rate to the resting metabolic rate. One MET is defined as 1 kcal/kg/hour and is roughly equivalent to the energy cost of sitting quietly. A MET also is defined as oxygen uptake in ml/kg/min with one MET equal to the oxygen cost of sitting quietly, equivalent to 3.5 ml/kg/min. The MET concept was primarily designed to be used in epidemiological surveys, where survey respondents answer the amount of time they spend for specific physical activities. MET is used to provide general medical thresholds and guidelines to a population. A MET is the ratio of the rate of energy expended during an activity to the rate of energy expended at rest. For example, 1 MET is the rate of energy expenditure while at rest. A 4 MET activity expends 4 times the energy used by the body at rest. If a person does a 4 MET activity for 30 minutes, he or she has done 4 x 30 = 120 MET-minutes (or 2.0 MET-hours) of physical activity. A person could also achieve 120 MET-minutes by doing an 8 MET activity for 15 minutes.

To calculate the amount of calories burned per minute, we can use the formula:

Calories burned per minute = (METs x 3.5 x (your body weight in Kg)) / 200
![image](https://github.com/mukul-bhele/fitnesstracker/blob/93b564d62a2efb3bed91c3972c3bb69f95b3a6e8/SQL%20Visualisations/MET%20Variations.png)
````sql
-- Average MET per day per use and Comparison with the calories burned
Select Distinct temp1.Id, temp1.ActivityDate, sum(temp1.METs) as sum_mets, temp2.Calories
From MET as temp1
inner join Daily_Activity as temp2
on temp1.Id = temp2.Id and temp1.ActivityDate = temp2.ActivityDate
Group By temp1.Id, temp1.ActivityDate, temp2.Calories
Order by ActivityDate
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY
````
![image](https://github.com/mukul-bhele/fitnesstracker/blob/a2267052fc7c6b697427e2c5c7e4dbc4a19bc660/SQL%20Visualisations/METs%20%26%20Calories.png)
![image](https://github.com/mukul-bhele/fitnesstracker/blob/a2267052fc7c6b697427e2c5c7e4dbc4a19bc660/SQL%20Visualisations/METs%20%26%20Calories%20Plot.png)
**Key Findings:**
 - The R-Squared value is 0.5504
 - There is a substantial positive correlation between METs and the average calories burned.
 - The amount of calories burned by each user is significantly influenced by their daily MET values. This is evident from the high R-squared value, indicating a robust relationship between the trend line and the data points.
