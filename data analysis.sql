select * from Zomato_Dataset$;

-- count and percentage of restuarant per country 
WITH RestaurantCounts AS (
    SELECT CountryName, COUNT(*) AS RestaurantCount
    FROM Zomato_Dataset$
    GROUP BY CountryName
)
, TotalRestaurantCount AS (
    SELECT SUM(RestaurantCount) AS TotalCount
    FROM RestaurantCounts
)
SELECT rc.CountryName, 
       rc.RestaurantCount, 
       (rc.RestaurantCount * 100.0 / trc.TotalCount) AS Percentage
FROM RestaurantCounts rc
CROSS JOIN TotalRestaurantCount trc
order by 2;


-- city(with locality) of india with max number of resturants
select city,Locality,count(RestaurantID) AS RestaurantCount from Zomato_Dataset$
group by City,Locality
Order by 3 DESC;


-- locality in india with minimum and maximum resturants
WITH RestaurantCounts AS (
    SELECT Locality, COUNT(*) AS RestaurantCount
    FROM Zomato_Dataset$
    WHERE CountryName = 'india'
    GROUP BY Locality
)

SELECT Locality, RestaurantCount
FROM RestaurantCounts
WHERE RestaurantCount = (SELECT MIN(RestaurantCount) FROM RestaurantCounts);

SELECT Locality, RestaurantCount
FROM RestaurantCounts
WHERE RestaurantCount = (SELECT MAX(RestaurantCount) FROM RestaurantCounts);



--best restaurants with moderate cost for two in india having indian cuisines
select *
FROM Zomato_Dataset$
WHERE CountryNaame = 'india'
AND [Has_Table_booking] = 'YES'
AND [Has_Online_delivery] = 'YES'
AND [Price_range] <= 3
AND [Votes] > 1000
AND [Average_Cost_for_two] < 1000
AND [Rating] > 4
AND [Cuisines] LIKE '%INDIA%';


--average rating of restuarants location wise
SELECT CountryName,City,Locality, 
COUNT(RestaurantID) TOTAL_REST ,ROUND(AVG(CAST(Rating AS DECIMAL)),2) AVG_RATING
FROM Zomato_Dataset$
GROUP BY CountryName,City,Locality
ORDER BY 4 DESC;


--restuarants offer table booking option in india where the max restaurants are listed in Zomato
WITH CT1 AS (
SELECT City,Locality COUNT(RestaurantID) REST_COUNT
FROM Zomato_Dataset$
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY;
),
CT2 AS (
SELECT Locality,REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1);
),
CT3 AS (
SELECT Localit],Has_Table_booking TABLE_BOOKING
FROM Zomato_Dataset$;
)
SELECT A.Locality, COUNT(A.TABLE_BOOKING) TABLE_BOOKING_OPTION
FROM CT3 A JOIN CT2 B
ON A.Locality = B.Locality
WHERE A.TABLE_BOOKING = 'YES'
GROUP BY A.Locality;
