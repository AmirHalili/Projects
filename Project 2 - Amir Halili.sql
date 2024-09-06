--------------------------
--PROJECT 2 AMIR HALILI --
--------------------------



--Question Number 1-
SELECT pp.ProductID
,pp.Name
,pp.Color
,pp.ListPrice
,pp.Size
FROM Production.Product pp
LEFT JOIN Sales.SalesOrderDetail sd
ON pp.ProductID = sd.ProductID
WHERE sd.ProductID IS NULL
ORDER BY pp.ProductID;


--Question Number 2-
SELECT sc.CustomerID
,sc.PersonID
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
WHERE sh.SalesOrderID IS NULL
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


--Question Number 5-
WITH CTE_RN
AS
(	SELECT 
		sh.SalesOrderID,
		sh.CustomerID,
		pp.LastName,
		pp.FirstName,
		sh.OrderDate,
		LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate,
		ROW_NUMBER() OVER (PARTITION BY sh.CustomerID ORDER BY sh.OrderDate DESC) AS RN
		FROM 
		Sales.SalesOrderHeader sh
		LEFT JOIN 
		 Person.Person pp ON pp.BusinessEntityID = sh.CustomerID)
SELECT SalesOrderID
,CustomerID
,LastName
,FirstName
,OrderDate AS LastOrder
,PreviousOrderDate
FROM 
CTE_RN
WHERE 
    RN = 1
ORDER BY 
    CustomerID;


--Question Number 6-
WITH YearlyOrder AS (
    SELECT 
        YEAR(sh.OrderDate) AS Year
        ,sh.SalesOrderID
        ,sh.CustomerID
        ,SUM(sd.UnitPrice * (1 - sd.UnitPriceDiscount) * sd.OrderQty) AS Total
    FROM Sales.SalesOrderHeader sh
    JOIN Sales.SalesOrderDetail sd 
    ON sh.SalesOrderID = sd.SalesOrderID
    GROUP BY YEAR(sh.OrderDate), sh.SalesOrderID, sh.CustomerID
					),
MAX_Year AS (
    SELECT Year
		   ,MAX(Total) AS MaxTotal
    FROM YearlyOrder
    GROUP BY Year
			)
SELECT 
yr.Year
,yr.SalesOrderID AS MaxSalesOrderID
,pp.LastName AS MaxLastName
,pp.FirstName AS MaxFirstName
,my.MaxTotal
FROM MAX_Year my
LEFT JOIN YearlyOrder yr 
ON my.Year = yr.Year 
AND my.MaxTotal = yr.Total
LEFT JOIN Sales.SalesOrderHeader sh 
ON yr.SalesOrderID = sh.SalesOrderID
LEFT JOIN sales.Customer sc
ON sc.CustomerID = sh.CustomerID
LEFT JOIN Person.Person pp
ON pp.BusinessEntityID = sc.PersonID
ORDER BY 
yr.Year;

 
--Question Number 7-
SELECT *
FROM	(SELECT MONTH (sh.OrderDate) AS 'Month'
				,Year (sh.OrderDate) AS 'Year'
				,sh.SalesOrderID
		 FROM Sales.SalesOrderHeader sh) sa
PIVOT (COUNT(sa.SalesOrderID) FOR [Year] IN ([2011],[2012],[2013],[2014])) PIV
ORDER BY Month;


--Question Number 8-
SELECT YEAR(sh.OrderDate) AS Year
,MONTH(sh.OrderDate) AS Month
,SUM(sh.SubTotal) AS MonthlyTotal
,SUM(SUM(sh.SubTotal)) OVER (PARTITION BY YEAR(sh.OrderDate) ORDER BY MONTH(sh.OrderDate) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS YearlyCumulativeTotal
FROM Sales.SalesOrderHeader sh
GROUP BY YEAR(sh.OrderDate)
,MONTH(sh.OrderDate)
UNION ALL
SELECT YEAR(sh.OrderDate) AS Year
,NULL AS Month
,NULL AS MonthlyTotal
,SUM(sh.SubTotal) AS YearlyCumulativeTotal
FROM Sales.SalesOrderHeader sh
GROUP BY YEAR(sh.OrderDate)
ORDER BY Year
,Month;


--Question Number 9-
SELECT hd.Name AS DepartmentName
,he.BusinessEntityID AS 'Employee''sld'
,CONCAT_WS(' ',pp.FirstName,pp.LastName) AS 'Employee''sFullName'
,he.HireDate
,CASE 
	WHEN DATEDIFF(MM,heh.StartDate,heh.EndDate) IS NULL THEN DATEDIFF(MM,heh.StartDate,GETDATE())
	ELSE DATEDIFF(MM,heh.StartDate,heh.EndDate)
	END AS Seniority
,LAG((pp.FirstName+' '+pp.LastName),1) OVER (PARTITION BY hd.Name ORDER BY heh.startdate) AS PreviuseEmpName
,LAG(he.HireDate,1) OVER (PARTITION BY hd.Name ORDER BY heh.startdate) AS PreviusEmpHDate
,DATEDIFF(DD,LAG(he.HireDate,1) OVER (PARTITION BY hd.Name ORDER BY heh.startdate),he.HireDate) AS DiffDays
FROM HumanResources.Employee he
JOIN HumanResources.EmployeeDepartmentHistory heh
ON he.BusinessEntityID = heh.BusinessEntityID
JOIN HumanResources.Department hd
ON heh.DepartmentID = hd.DepartmentID
JOIN Person.Person pp
ON he.BusinessEntityID = pp.BusinessEntityID
--GROUP BY hd.Name
ORDER BY hd.Name, HireDate DESC


--Question Number 10-
WITH CTE_CONCAT AS
(    SELECT
     he.BusinessEntityID
     ,he.HireDate
     ,heh.DepartmentID
     ,ROW_NUMBER() OVER (PARTITION BY he.BusinessEntityID ORDER BY heh.StartDate DESC) AS rn
     FROM HumanResources.Employee he
     JOIN HumanResources.EmployeeDepartmentHistory heh
	 ON he.BusinessEntityID = heh.BusinessEntityID
	 )
SELECT CTE.HireDate
,CTE.DepartmentID
,STRING_AGG(CONCAT_WS(' ',pp.BusinessEntityID,pp.LastName,pp.FirstName),' ,') AS TeamEmployees
FROM
CTE_CONCAT CTE
JOIN
Person.Person pp
ON CTE.BusinessEntityID = pp.BusinessEntityID
WHERE
CTE.rn = 1
GROUP BY
CTE.HireDate
,CTE.DepartmentID
ORDER BY
CTE.HireDate DESC;