--  Create Quartery tables using Union: Quarter 1: Jan, Feb, Mar
-- Quarter_1_JAN_FEB_MAR.sql

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
from `final_bike_share_2022.JAN_2022`
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
from `final_bike_share_2022.FEB_2022`
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
from `final_bike_share_2022.MAR_2022`


-- Select columns from Quarter_1_JAN_FEB_MAR.sql to preview union of tables

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
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
ORDER BY
ride_id DESC

-- Total trips in quarter 1: members vs casual riders

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
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR` )

-- Total trips per day of week: members vs casual riders

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
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by day_of_week)

-- Total bike types in quarter 1: members vs casual riders

SELECT
member_casual,
COUNTIF(rideable_type = 'classic_bike') AS classic_bike,
COUNTIF(rideable_type = 'electric_bike') AS electric_bike,
COUNTIF(rideable_type = 'docked_bike') AS docked_bike,
from `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual

-- Total bike types per month in quarter 1: members vs casual riders 

SELECT
member_casual,
ride_month,
COUNTIF(rideable_type = 'classic_bike') AS classic_bike,
COUNTIF(rideable_type = 'electric_bike') AS electric_bike,
COUNTIF(rideable_type = 'docked_bike') AS docked_bike,
from `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual, ride_month

-- Total bike types per day in quarter 1: members vs casual riders 

SELECT
member_casual,
day_of_week,
COUNTIF(rideable_type = 'classic_bike') AS classic_bike,
COUNTIF(rideable_type = 'electric_bike') AS electric_bike,
COUNTIF(rideable_type = 'docked_bike') AS docked_bike,
from `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual, day_of_week

-- Which day of the week day the most rides: members vs casual riders

SELECT
member_casual, 
day_of_week AS mode_day_of_week 
FROM 
(SELECT
DISTINCT member_casual, day_of_week, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(day_of_week) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, day_of_week)
WHERE
rn = 1
ORDER BY
member_casual DESC 

-- Start station in descending order by total trips: members vs casual riders

SELECT 
DISTINCT start_station_name,
SUM (CASE WHEN ride_id = ride_id AND start_station_name = start_station_name THEN 1 ELSE 0 END) AS total,
SUM (CASE WHEN member_casual = 'member' AND start_station_name = start_station_name THEN 1 ELSE 0 END) AS member,
SUM( CASE WHEN member_casual = 'casual' AND start_station_name = start_station_name THEN 1 ELSE 0 END) AS casual
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY 
start_station_name
ORDER BY 
total DESC

-- Max ride length in quarter 1: members vs casual riders

SELECT
member_casual,
ride_length
from `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
where member_casual = 'member'
order by ride_length desc

-- Min ride length in quarter 1: members vs casual riders 

SELECT
member_casual,
ride_length
from `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
where member_casual = 'member'
order by ride_length asc

--  Most used bike type in quarter 1: members vs casual riders 

SELECT
member_casual,
rideable_type AS mode_ride_type
FROM
(SELECT
DISTINCT member_casual, rideable_type, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(rideable_type) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, rideable_type)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Mode for ride length in quarter 1: members vs casual riders

SELECT
member_casual,
ride_length AS mode_ride_length
FROM
(SELECT
DISTINCT member_casual, ride_length, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_length) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, ride_length)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Most used start station in quarter 1: members vs casual riders 

SELECT
member_casual,
start_station_name AS mode_start_station_name
FROM
(SELECT
DISTINCT member_casual, start_station_name, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, start_station_name)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Most used end station in quarter 1: members vs casual riders

SELECT
member_casual,
end_station_name AS mode_end_station_name
FROM
(SELECT
DISTINCT member_casual, end_station_name, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, end_station_name)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Mode for ride start time in quarter 1: members vs casual riders

SELECT
member_casual,
ride_start_time AS mode_ride_start_time
FROM
(SELECT
DISTINCT member_casual, ride_start_time, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_start_time) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, ride_start_time)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Mode for ride end time in quarter 1: members vs casual riders

SELECT
member_casual,
ride_end_time AS mode_ride_end_time
FROM
(SELECT
DISTINCT member_casual, ride_end_time, ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(ride_end_time) DESC) rn
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
GROUP BY member_casual, ride_end_time)
WHERE
rn = 1
ORDER BY
member_casual DESC

-- Median bike type in quarter 1: members vs casual riders

SELECT
DISTINCT median_bike_type,
member_casual,
FROM
(SELECT ride_id, member_casual,rideable_type,
PERCENTILE_DISC(rideable_type, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_bike_type
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)

-- Median ride length in quarter 1: members vs casual riders

SELECT
DISTINCT median_ride_length,
member_casual,
FROM
(SELECT ride_id, member_casual,ride_length,
PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_ride_length
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)

-- Median ride length per month and day in quarter 1: members vs casual riders 

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
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)
group by median_ride_length, day_of_week, member_casual, ride_month
order by ride_month, day_of_week

-- Median start start station in quarter 1: members vs casual riders 

SELECT
DISTINCT median_start_station,
member_casual,
FROM
(SELECT ride_id, member_casual,ride_length,
PERCENTILE_DISC(start_station_name, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_start_station
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)

-- Median end station in quarter 1: members vs casual riders

SELECT
DISTINCT median_end_station,
member_casual,
FROM
(SELECT ride_id, member_casual,ride_length,
PERCENTILE_DISC(end_station_name, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_end_station
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)

-- Median start time in quarter 1: members vs casual riders

SELECT
DISTINCT median_start_time,
member_casual,
FROM
(SELECT ride_id, member_casual, ride_start_time,
PERCENTILE_DISC(ride_start_time, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_start_time
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)

-- Median end time in quarter 1: members vs casual riders

SELECT
DISTINCT median_start_time,
member_casual,
FROM
(SELECT ride_id, member_casual, ride_start_time,
PERCENTILE_DISC(ride_start_time, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) as median_start_time
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`)

-- Mean ride length in quarter 1: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual

-- Mean ride length per month in quarter 1: members vs casual riders

SELECT
member_casual,
ride_month,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual, ride_month

-- Mean ride length per day  in quarter 1: members vs casual riders

SELECT
member_casual,
day_of_week,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_length, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual, day_of_week

-- Mean start time in quarter 1: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_start_time, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_start_time, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual

-- Mean end time in quarter 1: members vs casual riders

SELECT
member_casual,
TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_end_time, TIME '00:00:00', SECOND)) AS INT64) SECOND) average_time,
FORMAT_TIME('%T', TIME_ADD(TIME '00:00:00', INTERVAL CAST(AVG(TIME_DIFF(ride_end_time, TIME '00:00:00', SECOND)) AS INT64) SECOND)) average_time_as_string
FROM `final_bike_share_2022.QUARTER_1_JAN_FEB_MAR`
group by member_casual
