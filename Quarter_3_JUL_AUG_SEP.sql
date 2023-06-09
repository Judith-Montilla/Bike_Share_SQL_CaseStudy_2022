-- Create Quarterly tables using Union: Quarter 3: July, August, September 2022
-- Quarter_3_APR_MAY_JUN.sql

select
ride_id,
rideable_type, 
ride_month,
start_date, 
end_date, 
day_of_week, 
extract (time FROM started_at AT TIME ZONE "America/Chicago") as ride_start_time,
extract (time FROM ended_at AT TIME ZONE "America/Chicago") as ride_end_time,
ride_length, 
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng, 
end_lat,
end_lng,
member_casual
from `final_bike_share_2022.JUL_2022`
UNION DISTINCT
select
ride_id,
rideable_type, 
ride_month,
start_date, 
end_date, 
day_of_week, 
extract (time FROM started_at AT TIME ZONE "America/Chicago") as ride_start_time,
extract (time FROM ended_at AT TIME ZONE "America/Chicago") as ride_end_time,
ride_length, 
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng, 
end_lat,
end_lng,
member_casual
from `final_bike_share_2022.AUG_2022`
UNION DISTINCT
select
ride_id,
rideable_type, 
ride_month,
start_date, 
end_date, 
day_of_week, 
extract (time FROM started_at AT TIME ZONE "America/Chicago") as ride_start_time,
extract (time FROM ended_at AT TIME ZONE "America/Chicago") as ride_end_time,
ride_length, 
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng, 
end_lat,
end_lng,
member_casual
from `final_bike_share_2022.SEP_2022`

-- Select columns from Quarter_3_JUL_AUG_SEP to preview union of tables

SELECT 
ride_id,
ride_start_time,
ride_end_time,
start_date,
end_date,
ride_length,
day_of_week,
start_station_name,
end_station_name,
member_casual
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
ORDER BY
ride_id DESC

-- Total bike trips in quarter 3: members vs casual riders

SELECT
TotalTrips,
TotalMemberTrips,
TotalCasualTrips,
ROUND(TotalMemberTrips/TotalTrips,2)*100 AS MemberPercentage,
ROUND(TotalCasualTrips/TotalTrips,2)*100 AS CasualPercentage
FROM
(SELECT
COUNT(ride_id) AS TotalTrips,
COUNTIF(member_casual = 'member') AS TotalMemberTrips,
COUNTIF(member_casual = 'casual') AS TotalCasualTrips,
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP` )

-- Total bike trips per month in quarter 3: members vs casual riders

SELECT
TotalTrips,
TotalMemberTrips,
TotalCasualTrips,
ride_month,
ROUND(TotalMemberTrips/TotalTrips,2)*100 AS MemberPercentage,
ROUND(TotalCasualTrips/TotalTrips,2)*100 AS CasualPercentage
FROM
(SELECT
ride_month,
COUNT(ride_id) AS TotalTrips,
COUNTIF(member_casual = 'member') AS TotalMemberTrips,
COUNTIF(member_casual = 'casual') AS TotalCasualTrips,
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by ride_month)

-- Total bike trips per day in quarter 3: members vs casual riders

SELECT
TotalTrips,
TotalMemberTrips,
TotalCasualTrips,
day_of_week,
ROUND(TotalMemberTrips/TotalTrips,2)*100 AS MemberPercentage,
ROUND(TotalCasualTrips/TotalTrips,2)*100 AS CasualPercentage
FROM
(SELECT
day_of_week,
COUNT(ride_id) AS TotalTrips,
COUNTIF(member_casual = 'member') AS TotalMemberTrips,
COUNTIF(member_casual = 'casual') AS TotalCasualTrips,
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by day_of_week)

-- Total bike types in quarter 3: members vs casual riders

SELECT
member_casual,
COUNTIF(rideable_type = 'classic_bike') AS classic_bike,
COUNTIF(rideable_type = 'electric_bike') AS electric_bike,
COUNTIF(rideable_type = 'docked_bike') AS docked_bike,
from `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual

-- Total bike types per month in quarter 3: members vs casual riders

SELECT
member_casual,
ride_month,
COUNTIF(rideable_type = 'classic_bike') AS classic_bike,
COUNTIF(rideable_type = 'electric_bike') AS electric_bike,
COUNTIF(rideable_type = 'docked_bike') AS docked_bike,
from `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual, ride_month

-- Total bike types per day in quarter 3: members vs casual riders

SELECT
member_casual,
day_of_week,
COUNTIF(rideable_type = 'classic_bike') AS classic_bike,
COUNTIF(rideable_type = 'electric_bike') AS electric_bike,
COUNTIF(rideable_type = 'docked_bike') AS docked_bike,
from `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual, day_of_week

-- Mode for bike type in quarter 3: members vs casual riders

SELECT
member_casual,
rideable_type AS mode_ride_type
FROM
(SELECT
DISTINCT member_casual, rideable_type, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(rideable_type) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, rideable_type)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Median for bike types in quarter 3: members vs casual riders

SELECT
DISTINCT median_bike_type,
member_casual,
FROM
(SELECT ride_id, member_casual,rideable_type,
PERCENTILE_DISC(rideable_type, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_bike_type
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)

-- Max ride length in quarter 3: members vs casual riders

SELECT
member_casual,
ride_length
from `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
where member_casual = 'member'
order by ride_length desc

-- Min ride length in quarter 3: members vs casual riders

SELECT
member_casual,
ride_length
from `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
where member_casual = 'member'
order by ride_length asc

 -- Which days have the highest number of rides in quarter 3: members vs casual riders
 
SELECT
member_casual, 
day_of_week AS mode_day_of_week 
FROM 
(SELECT
DISTINCT member_casual, day_of_week, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(day_of_week) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, day_of_week)
WHERE
rn = 1
ORDER BY
member_casual DESC 

-- Mode for ride length in quarter 3: members vs casual riders

SELECT
member_casual,
ride_length AS mode_ride_length
FROM
(SELECT
DISTINCT member_casual, ride_length, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_length) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, ride_length)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Median ride length in quarter 3: members vs casual riders

SELECT
DISTINCT median_ride_length,
member_casual,
FROM
(SELECT ride_id, member_casual,ride_length,
PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_ride_length
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)

-- Median ride length per day and month in quarter 3: members vs casual riders

SELECT
DISTINCT
median_ride_length,
member_casual,
ride_month,
day_of_week
FROM
(SELECT
ride_id,
member_casual,
ride_month,
day_of_week,
ride_length,
PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS  median_ride_length
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)
group by median_ride_length, day_of_week, member_casual, ride_month
order by ride_month, day_of_week

-- Mean for ride length in quarter 3: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual

-- Mean for ride length per month in quarter 3: members vs casual riders

SELECT
member_casual,
ride_month,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual, ride_month

-- Mean for ride length per day  in quarter 3: members vs casual riders

SELECT
member_casual,
day_of_week,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual, day_of_week

-- Mode for start station in quarter 3: members vs casual riders

SELECT
member_casual,
start_station_name AS mode_start_station_name
FROM
(SELECT
DISTINCT member_casual, start_station_name, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, start_station_name)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Median for start station in quarter 3: members vs casual riders

SELECT
DISTINCT median_start_station,
member_casual,
FROM
(SELECT ride_id, member_casual,ride_length,
PERCENTILE_DISC(start_station_name, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_start_station
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)

-- Mean for start station in quarter 3: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_start_time, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_start_time, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual

-- Mode for end station in quarter 3: members vs casual riders

SELECT
member_casual,
end_station_name AS mode_end_station_name
FROM
(SELECT
DISTINCT member_casual, end_station_name, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, end_station_name)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Median for end station in quarter 3: members vs casual riders

SELECT
DISTINCT median_end_station,
member_casual,
FROM
(SELECT ride_id, member_casual,ride_length,
PERCENTILE_DISC(end_station_name, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_end_station
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)

-- Mean for end station in quarter 3: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_end_time, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_end_time, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual

-- Mode for start time in quarter 3: members vs casual riders

SELECT
member_casual,
ride_start_time AS mode_ride_start_time
FROM
(SELECT
DISTINCT member_casual, ride_start_time, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_start_time) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, ride_start_time)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Median for start time in quarter 3: members vs casual riders

SELECT
DISTINCT median_start_time,
member_casual,
FROM
(SELECT ride_id, member_casual, ride_start_time,
PERCENTILE_DISC(ride_start_time, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_start_time
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)

-- Mean for start time in quarter 3: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_start_time, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_start_time, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual

-- Mode for end time in quarter 3: members vs casual riders

SELECT
member_casual,
ride_end_time AS mode_ride_end_time
FROM
(SELECT
DISTINCT member_casual, ride_end_time, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_end_time) DESC) rn
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
GROUP BY member_casual, ride_end_time)
WHERE
rn = 1
ORDER BY

-- Median for end time in quarter 3: members vs casual riders

SELECT
DISTINCT median_start_time,
member_casual,
FROM
(SELECT ride_id, member_casual, ride_start_time,
PERCENTILE_DISC(ride_start_time, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_start_time
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`)

-- Mean for end time in quarter 3: members vs casual riders 

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_end_time, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_end_time, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_3_JUL_AUG_SEP`
group by member_casual
