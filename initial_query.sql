-- Cyclistic Bike Share Case Study: Initial Query
-- Count Distinct: Total Rides Per Month

SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.JAN_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.FEB_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.MAR_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.APR_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.MAY_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.JUN_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.JUL_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.AUG_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.SEP_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.NOV_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.OCT_2022`
GROUP by ride_month
union distinct
SELECT
count (distinct ride_id) as total_monthly_rides,
ride_month
from `final_bike_share_2022.DEC_2022`
GROUP by ride_month 
