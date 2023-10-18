SELECT * FROM Zomato_Dataset$;

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
SELECT city,Locality ,COUNT(RestaurantID) AS RestaurantCount FROM Zomato_Dataset$
group by City,Locality
Order by 3 DESC;


-- locality in india with minimum and maximum resturants
WITH RestaurantCounts AS(
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



--which country how many restuarants have online delivery option with percentage  
CREATE COUNTRY_REST
AS(
SELECT [CountryName], COUNT(CAST([RestaurantID]AS NUMERIC)) REST_COUNT
FROM [dbo].[Zomato_Dataset$]
GROUP BY [CountryName]
)
SELECT * FROM COUNTRY_REST
ORDER BY 2 DESC

SELECT A.[COUNTRY_NAME],COUNT(A.[RestaurantID]) TOTAL_REST, 
ROUND(COUNT(CAST(A.[RestaurantID] AS DECIMAL))/CAST(B.[REST_COUNT] AS DECIMAL)*100, 2)
FROM [dbo].[ZomatoData1] A JOIN COUNTRY_REST B
ON A.[COUNTRY_NAME] = B.[COUNTRY_NAME]
WHERE A.[Has_Online_delivery] = 'YES'
GROUP BY A.[COUNTRY_NAME],B.REST_COUNT
ORDER BY 2 DESC



-- how rating affects in max listed restuarants with and without table booking option ( Connaught Place)
SELECT 'WITH_TABLE' TABLE_BOOKING_OPT,COUNT([Has_Table_booking]) TOTAL_REST, ROUND(AVG([Rating]),2) AVG_RATING
FROM [dbo].[ZomatoData1]
WHERE [Has_Table_booking] = 'YES'
AND [Locality] = 'Connaught Place'
UNION
SELECT 'WITHOUT_TABLE' TABLE_BOOKING_OPT,COUNT([Has_Table_booking]) TOTAL_REST, ROUND(AVG([Rating]),2) AVG_RATING
FROM [dbo].[ZomatoData1]
WHERE [Has_Table_booking] = 'NO'
AND [Locality] = 'Connaught Place'

    

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
