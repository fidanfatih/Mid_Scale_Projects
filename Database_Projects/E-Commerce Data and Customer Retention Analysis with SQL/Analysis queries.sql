--Analyze the data by finding the answers to the questions below:
use [e_commence]
select * from [dbo].[market_fact]
select * from [dbo].[orders_dimen]
select * from [dbo].[shipping_dimen]
select * from [dbo].[cust_dimen]
select * from [dbo].[prod_dimen]

update [dbo].[prod_dimen]
set [Prod_id]='Prod_16'
where [Prod_id]=' RULERS AND TRIMMERS,Prod_16';



--1. Join all the tables and create a new table with all of the columns, called
--combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen,
--shipping_dimen)

select *
into combined_table
from(
select m.[Ord_id],m.[Prod_id],m.[Ship_id],m.[Cust_id],[Sales],[Discount],[Order_Quantity],[Profit],[Shipping_Cost],[Product_Base_Margin],
		[Customer_Name],[Province],[Region],[Customer_Segment],
		[Order_Date],[Order_Priority],
		[Product_Category],[Product_Sub_Category],
		[Ship_Mode],[Ship_Date]

from [dbo].[market_fact] m
full join [dbo].[cust_dimen] c
on m.[Cust_id]=c.Cust_id
full join [dbo].[shipping_dimen] s
on m.Ship_id=s.Ship_id
full join [dbo].[orders_dimen] o
on m.Ord_id=o.Ord_id
full join [dbo].[prod_dimen] p
on m.Prod_id = p.[Prod_id]
) a

select * from combined_table
 

--2. Find the top 3 customers who have the maximum count of orders.

select top 3 [Cust_id], [Customer_Name], COUNT(distinct [Ord_id])  as [count of orders]
from combined_table
group by [Cust_id], [Customer_Name]
order by COUNT([Ord_id]) desc;

--3. Create a new column at combined_table as DaysTakenForDelivery that
--contains the date difference of Order_Date and Ship_Date.

alter table combined_table
add DaysTakenForDelivery int;

update combined_table
set DaysTakenForDelivery=DATEDIFF(day, [Order_Date], [Ship_Date]);

--4. Find the customer whose order took the maximum time to get delivered.

select top 1 [Customer_Name], DaysTakenForDelivery
from combined_table
order by DaysTakenForDelivery desc;

--or

select [Customer_Name],DaysTakenForDelivery
from combined_table
where DaysTakenForDelivery= (select max(DaysTakenForDelivery)
							from combined_table)

--5. Retrieve total sales made by each product from the data (use Window function)

select distinct [Prod_id], sum([Sales]) over (partition by [Prod_id]) as total_sales
from combined_table
order by total_sales desc;

--6. Retrieve total profit made from each product from the data (use windows
--function)

select distinct [Prod_id], sum([Profit]) over (partition by [Prod_id]) as total_profit
from combined_table
order by total_profit desc;

--select * from combined_table

--7. Count the total number of unique customers in January and how many of them
--came back every month over the entire year in 2011

select distinct month([Order_Date]) [month],
				year([Order_Date]) [year], 
				count(Cust_id) over(partition by month([Order_Date]) order by month([Order_Date])) total_cust
from combined_table
where year([Order_Date])=2011 and 
			Cust_id in (
						select [Cust_id] as [number of unique customers]
						from combined_table
						where month([Order_Date])=01 and year([Order_Date])=2011)
order by [month];

--or

select  month([Order_Date]) [month],
		year([Order_Date]) [year], 
		count(Cust_id) total_cust
from combined_table
where year([Order_Date])=2011 and 
			Cust_id in (
						select [Cust_id] as [number of unique customers]
						from combined_table
						where month([Order_Date])=01 and year([Order_Date])=2011 )
group by year([Order_Date]), month([Order_Date])
order by [month];

--Find month-by-month customer retention rate since the start of the business
--(using views).

--1. Create a view where each user’s visits are logged by month, allowing for the
--possibility that these will have occurred over multiple years since whenever
--business started operations.

CREATE VIEW visits as 
select	Cust_id, 
		count (*) count_in_month,
		SUBSTRING(CAST( Order_Date as varchar),1,7) as [month]
		--OR
		--SUBSTRING(CONVERT(varchar,Order_Date),1,7) as [month]
from combined_table
group by Cust_id, SUBSTRING(CAST( Order_Date as varchar),1,7);

									--SELECT SUBSTRING('Clarusway',1,5);		-->> Claru
									--SELECT CAST(25.65 AS int);				-->> 25
									--SELECT CAST(25.65 AS varchar);			-->> 25.65
									--SELECT CAST('2017-08-25' AS datetime);	-->> 2017-08-25 00:00:00.000
									--SELECT CONVERT(date, '2009'+'-01-01');	-->> 2017-08-25 00:00:00.000
									--SELECT CONVERT(int, 25.65); 				-->> 25

select *
from visits
order by 1;

--2. Identify the time lapse between each visit. So, for each person and for each
--month, we see when the next visit is.

select	Cust_id,count_in_month,[month] as month_of_order, 
		SUBSTRING(LEAD(month_time) over (partition by Cust_id order by month_time),1,7) month_of_next_order
from (	select *, 
		CONVERT(varchar, 
		[month]+'-1') as month_time
		from visits) a;

select * from combined_table
--3. Calculate the time gaps between visits.
CREATE VIEW time_gap as 
select	*, DATEDIFF(MONTH, CONVERT(date, Order_Date) , CONVERT( date, next_order_date)) as month_diff
		   --DATEDIFF(day, CASE (Order_Date as date) , CASE( next_order_date as date)) as date_diff
from	(select	*, LEAD(Order_Date) over (partition by Cust_id order by Order_Date) as next_order_date	
			from (	select	Cust_id, 
					count (*) count_in_month,
					Order_Date
					from combined_table
					group by Cust_id,Order_Date) a) b;

												--SELECT DATEDIFF(month, '2017-08-25', '2011-08-25');  -->>-72
select *
from time_gap;

--4. Categorise the customer with time gap 1 as retained, >1 as irregular and NULL
--as churned.

CREATE VIEW segmentation as 
select  *, 
		CASE
			WHEN average_time_gap is NULL THEN 'churned'
			WHEN average_time_gap >1 THEN 'irregular'
			WHEN average_time_gap <=1	THEN 'retained'
			ELSE 'unknowed data'
		END as customer_segment
from (	select *,AVG(month_diff) over (partition by Cust_id) as average_time_gap
		from time_gap) a;

select distinct Cust_id, customer_segment, average_time_gap
from segmentation
where average_time_gap<=1
order by Cust_id;


--5. Calculate the retention month wise.
--retention: ay icinde alisveris yapan 'retained' musteri sayisi

select	distinct substring(cast(next_order_date as varchar),1,7) as [month],
		count(average_time_gap) over (partition by substring(cast(next_order_date as varchar),1,7 )) as retained_cust_num_of_prev_month 
from segmentation
where average_time_gap <=1 and substring(cast(next_order_date as varchar),1,7) is not NULL  
order by 2 desc;