USE Superstore;
GO

/* Calculate the number of days it took to ship each order and compare it to the average
	shipping time of each shipping method. Label the results as 'Average', 'Below Average', 
	or 'Above Average' and display the number of days above or below average. */


SELECT
	OrderID,
	CustomerName,
	OrderDate,
	ShipDate,
	ShipMode,
	DATEDIFF(day, OrderDate, ShipDate) as DaysToShip,
	AVG(DATEDIFF(day, OrderDate, ShipDate)) OVER(PARTITION BY ShipMode) AS AverageDTS,
	IIF(DATEDIFF(day, OrderDate, ShipDate) > AVG(DATEDIFF(day, OrderDate, ShipDate)) OVER(PARTITION BY ShipMode), 'Above Average', 
	IIF(DATEDIFF(day, OrderDate, ShipDate) < AVG(DATEDIFF(day, OrderDate, ShipDate)) OVER(PARTITION BY ShipMode), 'Below Average', 'Average')) AS Result,
	ABS(DATEDIFF(day, OrderDate, ShipDate) - AVG(DATEDIFF(day, OrderDate, ShipDate)) OVER(PARTITION BY ShipMode)) AS DayDifference
FROM Summary
GROUP BY OrderID, CustomerName, OrderDate, ShipDate, ShipMode
ORDER BY OrderID


/* Select the top 3 customers for each year based on total sales amount. */


SELECT * 
FROM
	(SELECT 
		SalesByYear.*,
		RANK() OVER(PARTITION BY SalesByYear.SalesYear ORDER BY SalesByYear.TotalSales DESC) AS Ranking
	FROM	
		(SELECT
			CustomerID,
			CustomerName,
			YEAR(OrderDate) AS SalesYear,
			ROUND(SUM(Sales),2) AS TotalSales
		FROM Summary
		GROUP BY CustomerID, CustomerName, YEAR(OrderDate)) AS SalesByYear) AS Result
WHERE Result.Ranking < 4


/* Identify if the purchase from a customer is higher or lower than their previous purchase. */


SELECT *,
	LAG(SaleTotal) OVER (PARTITION BY CustomerID ORDER BY OrderID) AS PrevSaleTotal
FROM 
	(SELECT
		OrderID,
		OrderDate,
		CustomerID,
		CustomerName,
		ROUND(SUM(Sales),2) AS SaleTotal
	FROM Summary
	GROUP BY OrderID, OrderDate, CustomerID, CustomerName) AS Result


/* Identify all customers that have more than 5 yearly orders, and the total amount
spent. Declare a variable to run the query for each individual year. */


DECLARE @YEAR AS INT = 2016

SELECT 
	CustomerName,
	COUNT(OrderID) AS OrderCount,
	ROUND(SUM(Result.SaleTotal),2) AS SalesTotal
FROM
	(SELECT
		OrderID,
		OrderDate,
		CustomerID,
		CustomerName,
		SUM(Sales) AS SaleTotal
	FROM Summary
	GROUP BY OrderID, OrderDate, CustomerID, CustomerName) AS Result
WHERE YEAR(OrderDate) = @Year
GROUP BY CustomerName
HAVING COUNT(OrderID) > 5
ORDER BY OrderCount DESC


/* Calculate the average total sales with respect to each customer. */


SELECT ROUND(AVG(TotalSalesCustomer),2) AS AvgSales
FROM
	(SELECT
		CustomerID,
		ROUND(SUM(Sales),2) AS TotalSalesCustomer
	FROM Summary
	GROUP BY CustomerID) AS TotalSales


/* Identify all customers whose total sales amount is higher than the average. */


WITH 
	Total_Sales (CustomerID, CustomerName, TotalSalesPerCustomer) AS
		(SELECT
			CustomerID,
			CustomerName,
			ROUND(SUM(Sales),2) AS TotalSalesPerCustomer
		FROM Summary
		GROUP BY CustomerID, CustomerName),
	Average_Sales (AvgSales) AS
		(SELECT 
			ROUND(AVG(TotalSalesPerCustomer),2) AS AvgSales
		FROM Total_Sales)
SELECT * 
FROM Total_Sales ts
JOIN Average_Sales av ON ts.TotalSalesPerCustomer > av.AvgSales