

 Question: DAY 1

--A ski resort company want to know which customers rented ski equipment for more than one type of activity (e.g., skiing and snowboarding). List the customer names and the number of distinct activities they rented equipment for.
SELECT
customer_name,
COUNT(distinct activity)
FROM rentals
GROUP BY customer_name
HAVING COUNT(distinct activity) >1


 Question: DAY 2
--Santa wants to know which gifts weigh more than 1 kg. Can you list them?

SELECT
 gift_name
 FROM gifts
 WHERE weight_kg>1

 --Question: DAY 3
--You’re trying to identify the most calorie-packed candies to avoid during your holiday binge. Write a query to rank candies based on their calorie count within each category. Include the candy_name, candy_category, calories, and rank (rank_in_category) within the category.

SELECT 
candy_name,
candy_category,
calories,
DENSE_RANK()OVER(PARTITION BY candy_category order by calories desc) as rank_in_category
FROM candy_nutrition

--Question: DAY 4
--You’re planning your next ski vacation and want to find the best regions with heavy snowfall. Given the tables resorts and snowfall, find the average snowfall for each region and sort the regions in descending order of average snowfall. Return the columns region and average_snowfall.

SELECT 
ski.region,
AVG(snf.snowfall_inches)
FROM ski_resorts as ski
JOIN snowfall as snf 
ON  ski.resort_id =snf.resort_id
GROUP BY region
ORDER BY AVG(snowfall_inches) desc
-- Question: DAY 5
--This year, we're celebrating Christmas in the Southern Hemisphere! Which beaches are expected to have temperatures above 30°C on Christmas Day?

SELECT 
beach_name 
FROM beach_temperature_predictions 
WHERE expected_temperature_c>30 AND date ='2024-12-25'

--Question: Day 6
--Scientists are tracking polar bears across the Arctic to monitor their migration patterns and caloric intake. Write a query to find the top 3 polar bears that have traveled the longest total distance in December 2024. Include their bear_id, bear_name, and total_distance_traveled in the results.
SELECT 
p.bear_id, 
p.bear_name,
sum(t.distance_km) as total_distance_travel
FROM polar_bears AS p
JOIN tracking as t
ON P.bear_id =t.bear_id 
WHERE date BETWEEN '2024-12-01' AND '2024-12-31'
group by p.bear_name,p.bear_id
ORDER BY  sum(t.distance_km) DESC
LIMIT 3


--Question: DAY 7
--The owner of a winter market wants to know which vendors have generated the highest revenue overall. For each vendor, calculate the total revenue for all their items and return a list of the top 2 vendors by total revenue. Include the vendor_name and total_revenue in your results.
SELECT
v.vendor_name,
SUM(s.quantity_sold*s.price_per_unit) as total_revenue
FROM vendors v
join sales s
ON v.vendor_id = s.vendor_id
GROUP BY vendor_name
ORDER BY  SUM(s.quantity_sold*s.price_per_unit) desc 
limit 2;

--Question: DAY 8
--You are managing inventory in Santa's workshop. Which gifts are meant for "good" recipients? List the gift name and its weight.
SELECT 
gift_name,
weight_kg
FROM gifts
WHERE recipient_type ='good'

 --Question: DAY 9
--A community is hosting a series of festive feasts, and they want to ensure a balanced menu. Write a query to identify the top 3 most calorie-dense dishes (calories per gram) served for each event. Include the dish_name, event_name, and the calculated calorie density in your results.

WITH calories as
(SELECT 
me.dish_name,
ev.event_name,
(calories/weight_g) as calories_density,
ROW_NUMBER() OVER(PARTITION BY ev.event_id order by(calories/weight_g) DESC) as calories_per_gram
FROM events as ev
JOIN menu as me 
ON ev.event_id = me.event_id
)
SELECT * 
FROM calories
WHERE calories_per_gram <=3
ORDER BY calories_density DESC


--Today's Question:  day 10
--You are tracking your friends' New Year’s resolution progress. Write a query to calculate the following for each friend: number of resolutions they made, number of resolutions they completed, and success percentage (% of resolutions completed) and a success category based on the success percentage:
--- Green: If success percentage is greater than 75%.
--- Yellow: If success percentage is between 50% and 75% (inclusive).
---Red: If success percentage is less than 50%.

WITH percentatge as 
(SELECT
friend_name,
COUNT(*) as total_resolutions,
SUM(is_completed) as number_completed,
(SUM(is_completed)*100/COUNT(is_completed)) as success_percentage
FROM resolutions
GROUP BY friend_name
)
SELECT
friend_name,
total_resolutions,
number_completed,
success_percentage,
CASE
WHEN success_percentage >=75 THEN 'GREEN' 
WHEN success_percentage <50 THEN 'RED'
ELSE 'YELLOW'
END AS success_category
FROM percentatge


--Today's Question:  day 11
---You are preparing holiday gifts for your family. Who in the family_members table are celebrating their birthdays in December 2024? List their name and birthday.

SELECT 
name_,
birthday 
FROM family_members 
WHERE birthday BETWEEN '2024-12-01' AND '2024-12-31'

--Question: DAY 12
--A collector wants to identify the top 3 snow globes with the highest number of figurines. Write a query to rank them and include their globe_name, number of figurines, and material

WITH exam as
(SELECT
sn.globe_name,
sn.material,
COUNT(fi.figurine_id),
DENSE_RANK() OVER( ORDER BY count(*) desc) as ranking
FROM snow_globes as sn
JOIN figurines as fi 
ON sn.globe_id = fi.globe_id
GROUP  BY sn.globe_name,sn.material
)
SELECT *
FROM exam
WHERE ranking <=3


--Question: DAY 13
--We need to make sure Santa's sleigh is properly balanced. Find the total weight of gifts for each recipient.

SELECT 
recipient,
SUM(weight_kg)
FROM gifts
GROUP BY recipient;

--Question: DAY 14
--Which ski resorts had snowfall greater than 50 inches?

SELECT
resort_name
FROM snowfall
where snowfall_inches >50;

-- Question: Day 15
--A family reunion is being planned, and the organizer wants to identify the three family members with the most children.
--Write a query to calculate the total number of children for each parent and rank them. Include the parent’s name and their total number of children in the result.
SELECT 
name_,
COUNT(child_id)
FROM family_members as fm 
JOIN parent_child_relationships as pcr 
ON fm.member_id = pcr.parent_id
GROUP BY  name_
order by COUNT(child_id) desc
limit 3

--Question: DAY 16
--As the owner of a candy store, you want to understand which of your products are selling best. 
--rite a query to calculate the total revenue generated from each candy category.
SELECT 
category,
SUM(quantity_sold * price_per_unit) as revenue
FROM candy_sales 
GROUP BY category 
ORDER BY SUM(quantity_sold * price_per_unit) DESCSELECT 
category,
SUM(quantity_sold * price_per_unit) as revenue
FROM candy_sales 
GROUP BY category 
ORDER BY SUM(quantity_sold * price_per_unit) DESC


--Question: DAY 17

--The Grinch is planning out his pranks for this holiday season. 
--Which pranks have a difficulty level of “Advanced” or “Expert"? 
--List the prank name and location (both in descending order).
SELECT
prank_name,
location_
FROM grinch_pranks
WHERE difficulty in ('Advanced','Expert')
ORDER BY  prank_name DESC, location DESC


--Question: DAY 18

--A travel agency is promoting activities for a "Summer Christmas" party. They want to identify the top 2 activities based on the average rating. 
--Write a query to rank the activities by average rating.

SELECT
 a.activity_id,
AVG(r.rating) as average
 FROM activities as a
 JOIN activity_ratings as r
 ON a.activity_id = r.activity_id
 GROUP BY a.activity_id
 ORDER BY AVG(r.rating) desc 
 LIMIT  2

Question: DAY 19
--Scientists are studying the diets of polar bears.
--Write a query to find the maximum amount of food (in kilograms) consumed by each polar bear in a single meal December 2024. 
--Include the bear_name and biggest_meal_kg, and sort the results in descending order of largest meal consumed.

SELECT 
bear_name,
MAX(food_weight_kg)
FROM polar_bears AS p
JOIN meal_log AS m
ON p.bear_id = m.bear_id
WHERE date between  '2024-12-01' and '2024-12-31'
GROUP BY bear_name
ORDER BY MAX(food_weight_kg) DESC 


--Question: DAY 20
--We are looking for cheap gifts at the market. 
--Which vendors are selling items priced below $10? List the unique (i.e. remove duplicates) vendor names.

SELECT 
distinct(v.vendor_name)
FROM vendors as v
JOIN item_prices as ip_
ON v.vendor_id = ip_.vendor_id
WHERE price_usd <=10

--Question: DAY 21
--Santa needs to optimize his sleigh for Christmas deliveries. 
--Write a query to calculate the total weight of gifts for each recipient type (good or naughty) and determine what percentage of the total weight is allocated to each type. 
--Include the recipient_type, total_weight, and weight_percentage in the result.

  SELECT 
recipient_type,
SUM(weight_kg),
SUM(weight_kg)/
(SELECT
SUM(weight_kg)
FROM gifts) as percentage
FROM gifts
GROUP BY recipient_type


--Question: DAY 22
--We are hosting a gift party and need to ensure every guest receives a gift.
--Using the guests and guest_gifts tables, write a query to identify the guest(s) who have not been assigned a gift (i.e. they are not listed in the guest_gifts table).

SELECT 
guest_name
FROM guests as g
LEFT JOIN guest_gifts as gg 
ON g.guest_id = gg.guest_id
WHERE gift_name is null

--Question: DAY 23
--The Grinch tracked his weight every day in December to analyze how it changed daily. 
--Write a query to return the weight change (in pounds) for each day, calculated as the difference from the previous day's weight.
SELECT 
day_of_month,
weight_,
LAG(weight_,1) OVER( ORDER BY day_of_month ) as diff ,
weight_ -LAG(weight,1) OVER ( ORDER BY day_of_month )as var_diff 
FROM grinch_weight_log

--Question: 24

--He wants a running total to see how many gifts have been delivered so far on any given night. 
--Using the deliveries table, calculate the cumulative sum of gifts delivered, ordered by the delivery date.

SELECT 
sum(gifts_delivered) over(order by delivery_date)as total_delivery

FROM deliveries