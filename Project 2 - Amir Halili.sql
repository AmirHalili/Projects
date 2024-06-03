--Question Number 1-***
SELECT pp.ProductID
,pp.Name
,pp.Color
,pp.ListPrice
,pp.Size
FROM Production.Product pp
WHERE pp.ListPrice =0
ORDER BY pp.ProductID;

--Question Number 2-
SELECT sc.CustomerID
,	CASE 
           WHEN pp.LastName IS NULL THEN 'Unknown'
           ELSE pp.LastName
	END AS LastName
,	CASE 
           WHEN pp.FirstName IS NULL THEN 'Unknown'
           ELSE pp.FirstName 
    END AS FirstName
FROM Sales.Customer sc
LEFT JOIN Sales.SalesOrderHeader sh
ON sc.CustomerID = sh.CustomerID
LEFT JOIN Person.Person pp
ON sc.CustomerID = pp.BusinessEntityID
WHERE sc.PersonID IS NULL
ORDER BY sc.CustomerID;

--Question Number 3-
SELECT TOP 10 sh.CustomerID
,pp.FirstName
,pp.LastName
,COUNT(sh.SalesOrderID) AS 'CountOfOrders' 
FROM Sales.SalesOrderHeader sh
JOIN Person.Person pp
ON sh.CustomerID = pp.BusinessEntityID
GROUP BY sh.CustomerID
,pp.FirstName
,pp.LastName
ORDER BY 'CountOfOrders' DESC
,sh.CustomerID

--Question Number 4-
SELECT pp.FirstName
,pp.LastName
,he.JobTitle
,he.HireDate
,COUNT (*) OVER(PARTITION BY he.JobTitle) AS 'CountOfTitle'
FROM HumanResources.Employee he
JOIN Person.Person pp
ON pp.BusinessEntityID = he.BusinessEntityID

--Question Number 5-***
WITH CTE_RN
AS
(	SELECT 
		sh.SalesOrderID,
		sh.CustomerID,
		pp.LastName,
		pp.FirstName,
		sh.OrderDate,
		LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS LAG,
		ROW_NUMBER() OVER (PARTITION BY sh.CustomerID ORDER BY sh.OrderDate DESC) AS RN
		FROM 
		Sales.SalesOrderHeader sh
		LEFT JOIN 
		 Person.Person pp ON pp.BusinessEntityID = sh.CustomerID)
SELECT SalesOrderID
,CustomerID
,LastName
,FirstName
,OrderDate
,LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
FROM 
CTE_RN
WHERE 
    RN = 1
ORDER BY 
    CustomerID;