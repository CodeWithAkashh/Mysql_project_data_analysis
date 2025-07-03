Create database if not exists salesdatawalmart;
use salesdatawalmart;

create table sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
productline varchar(100) not null,
unit_price DECIMAL(10,2) not null,
quantity int not null,
vat FLOAT(6,4) not null,
total DECIMAL(12,4) not null,
date datetime not null,
time TIME not null,
payment_method varchar(15) not null,
cogs DECIMAL(10,2) not null,
gross_margin_percentage FLOAT(11,9),
gross_income DECIMAL(10,2) not null,
rating FLOAT(2,1)
);


-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------Feature Engineering -This will help use generate some new columns from existing ones --------------------------


-- 1. Time_of_Day - created a column which diversify the time of the day


select time, 
(case
when 'time' between "00:00:00" and "12:00:00" then "Morning"
when 'time' between "12:01:00" and "16:00:00" then "afternoon"
else "Evening"
end) as time_of_day
from sales;

-- create a column in table-----
alter table sales add column time_of_day varchar(20) not null;

SET SQL_SAFE_UPDATES = 0;
-- Update the column------
update sales
set time_of_day = (
case
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "afternoon"
else "Evening"
end
);

-- 2. Day_name - created a column which diversify the day name

alter table sales add column day_name varchar(30);
update sales
set day_name = (
dayname(date));

-- 2. Month_name - created a column which diversify the month name

alter table sales add column month_name varchar(30);
update sales
set month_name = (
monthname(date));


-- generic questions ----------------------------------------------------------------------------
-- 1. How many unique cities does the data have?
select distinct city from sales;

-- 2. In which city is each branch?
select distinct city, branch from sales;


-- Product questions ----------------------------------------------------------------------------
-- 1. How many unique product lines does the data have?
select count(distinct productline) from sales;

-- 2. What is the most common payment method?
select payment_method, count(payment_method) 
from sales
group by payment_method;


-- 3.What is the most selling product line?
Select productline, count(productline)
from sales
group by productline;

-- 4.What is the total revenue by month?
Select month_name, sum(total) as rev 
from sales
group by month_name
order by rev desc;

-- 5.What month had the largest COGS?

select month_name, sum(cogs) as cumsum
from sales
group by month_name
order by cumsum desc;

-- 6. What month had the Least COGS?

select month_name, sum(cogs) as cumsum
from sales
group by month_name
order by cumsum desc;

-- 7.What product line had the largest revenue?

Select productline, sum(total) as rev
from sales
group by productline 
order by rev desc;

-- 8. What is the city with the largest revenue?


select city, sum(total) as rev
from sales
group by city
order by rev desc
limit 1; 

-- 9. What product line had the largest VAT?

select productline, sum(vat) as vat
from sales
group by productline
order by vat desc;

-- 10. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 
select productline, avg(total), 
case 
when avg(total)>(select avg(total) from sales) then 'good'
else 'bad'
end as goodorbad
from sales
group by productline;


-- 11. Which branch sold more products than average product sold?

select branch, avg(quantity) as qty,
case
when avg(quantity)>(select avg(quantity) from sales) then 'more'
else 'less'
end as moreorless
from sales
group by branch;


-- 12. What is the most common product line by gender?

select gender, productline, count(productline) as pl
from sales
group by gender, productline
order by pl desc;



-- Sales

-- 1. Number of sales made in each time of the day per weekday

select day_name, time_of_day, count(quantity) as qty
from sales
group by day_name, time_of_day
order by day_name desc;

-- 2. Which of the customer types brings the most revenue?

select customer_type, sum(total) as rev
from sales
group by customer_type
order by rev desc;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, sum(vat) as vat
from sales
group by city
order by vat desc;

-- 4. Which customer type pays the most in VAT?

select customer_type, sum(vat) as vat
from sales
group by customer_type
order by vat desc;

-- Customer

-- 1. How many unique customer types does the data have?

select distinct customer_type from sales;

-- 2. How many unique payment methods does the data have?

select distinct payment_method from sales;

-- 3. What is the most common customer type?

select customer_type, count(customer_type) as nos
from sales
group by customer_type
order by nos desc;

-- 4. Which customer type buys the most?

select customer_type, sum(quantity) as qty
from sales
group by customer_type
order by qty desc;

-- 5. What is the gender of most of the customers?

select gender, count(gender) as genderr
from sales
group by gender
order by genderr desc;

-- 6. What is the gender distribution per branch?

select branch, gender, count(gender) as gender_count
from sales
group by branch, gender
order by branch asc;

-- 7. Which time of the day do customers give most ratings?

select time_of_day, count(rating) as rate
from sales
group by time_of_day
order by rate desc;

-- 8. Which time of the day do customers give most ratings per branch?

select branch, time_of_day, count(rating) as rating
from sales
group by branch, time_of_day
order by branch, rating desc;



