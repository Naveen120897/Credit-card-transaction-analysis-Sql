#1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

select city, sum(amount) as total_amount, round(100*(sum(amount)/(select sum(amount) from projects.cc_transactions)),2) as percentage from projects.cc_transactions 
group by city
order by total_amount desc limit 5

#2- write a query to print highest spend month and amount spent in that month for each card type

select  card_type, cumulative_amount from (select  card_type, sum(amount) over(partition by card_type order by transaction_date)  as cumulative_amount from projects.cc_transactions) as temp 
where cumulative_amount <= 1000000
order by card_type

#3- write a query to print the transaction details(all columns from the table) for each card type it when 
reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type

select  card_type, cumulative_amount from (select  card_type, sum(amount) over(partition by card_type order by transaction_date)  as cumulative_amount from projects.cc_transactions) as temp 
where cumulative_amount <= 1000000
order by card_type

#4- write a query to find city which had lowest percentage spend for gold card type

select city ,card_type, round(100*(sum(amount)/(select sum(amount) from projects.cc_transactions)),2) as percentage from projects.cc_transactions
where card_type = 'Gold' 
group by city
order by percentage asc, city asc limit 50

5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

SET @@local.net_read_timeout=360 ;
select distinct t1.city, t2.exp_type as lowest_exp_type ,t3.exp_type as highest_exp_type from (
select city, min(amount) as lowest_amount, max(amount) as highest_amount from projects.cc_transactions group by city) as t1 
join projects.cc_transactions as  t2 on t1.city = t2.city and t1.lowest_amount = t2.amount 
join projects.cc_transactions as t3 on t1.city = t3.city and t1.highest_amount = t3.amount

#6- write a query to find percentage contribution of spends by females for each expense type

select exp_type, round(100*sum(amount)/ (select sum(amount) from projects.cc_transactions where gender = 'F'),2) as female_exp_percentage from projects.cc_transactions
where gender = 'F' 
group by exp_type
order by female_exp_percentage

#7- which card and expense type combination saw highest month over month 

select card_type, exp_type, month(transaction_date) as months, sum(amount) as total_amount from projects.cc_transactions
group by exp_type, card_type, month(transaction_date)

#8- during weekends which city has highest total spend to total no of transcations ratio 

select city, dayname(transaction_date) as day_ , (sum(amount)/count(transaction_id)) as ratio from projects.cc_transactions
where dayname(transaction_date) in ('saturday', 'sunday')
group by city, transaction_date
order by (sum(amount)/count(transaction_id)) desc limit 1

#9- which city took least number of days to reach its 500th transaction after the first transaction in that city

WITH city_transactions AS (
  SELECT city,
         datediff(max(transaction_date), min(transaction_date)) AS no_of_days
  FROM projects.cc_transactions
  GROUP BY city
  HAVING count(*) = 500
)
SELECT city, min(no_of_days) AS min_days
FROM city_transactions
GROUP BY city;

