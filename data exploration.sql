use project  -- database


-- checking the datatype of each column

select column name, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Zomato_Dataset$'	
select * from Zomato_Dataset$;


-- adding a new column "CountryName" in reference to country code

create table name(id int primary key, name varchar(100));
insert into name values(1,'india'),
(14,'australia'),
(30,'brazil'),
(37,'canada'),
(94,'indonesia'),
(148,'new zealand'),
(162,'philippines'),
(166,'qatar'),
(184,'singapore'),
(189,'south africa'),
(191,'sri lanka'),
(208,'turkey'),
(214,'United Arab Emirates'),
(215,'united kingdom'),
(216,'united states');

alter table Zomato_Dataset$ 
ADD [CountryName] varchar(100);

UPDATE a
SET a.CountryName = b.CountryName
from Zomato_Dataset$ a
JOIN name b ON a.CountryCode = b.id;


-- checking for duplicate
select RestaurantID,COUNT(RestaurantID) from 
Zomato_Dataset$
group by RestaurantID
order by 2 DESC;


-- City
select distinct city from Zomato_Dataset$;

update Zomato_Dataset$ set city = REPLACE(city,'?','i') 
from Zomato_Dataset$ where city like '%?%';

-- drop unwanted column
alter table Zomato_Dataset$ drop column address;
alter table Zomato_Dataset$ drop column LocalityVerbose;
alter table Zomato_Dataset$ drop column Switch_to_order_menu;

-- currency
select distinct CountryName , Currency from Zomato_Dataset$
order by 2;

select  Currency,count(Currency) from Zomato_Dataset$
group by Currency;


-- price range
select distinct(Price_range) , count(Price_range) from Zomato_Dataset$
group by Price_range;

-- rating 
select min(Rating) as mini , max(Rating) as maxi ,
round(avg(Rating),2) as av from Zomato_Dataset$;

alter table Zomato_Dataset$ add category varchar(20);
update Zomato_Dataset$ set category = (case 
when Rating < 2.5 then 'poor'
when Rating >= 2.5 and Rating < 4.5 then 'good'
else 'excellent'
end)

-- has_table_booking
select distinct(Has_Table_booking) from Zomato_Dataset$;

-- has_online_delivery
select distinct(Has_Online_delivery) from Zomato_Dataset$;

-- is_delivering_now
select distinct(Is_delivering_now) from Zomato_Dataset$;


select * from Zomato_Dataset$;