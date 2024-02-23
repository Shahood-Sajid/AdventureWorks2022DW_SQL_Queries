-- Analysis for [dbo].[FactInternetSales]

select * from [dbo].[FactInternetSales]

-- sales by product
select Distinct ProductKey, sum(SalesAmount) AS SalesBYProduct from [dbo].[FactInternetSales]
group by ProductKey
Order By SalesBYProduct DESC

-- sales per customer
select CustomerKey, sum(SalesAmount) As "Sales per Customer" from [dbo].[FactInternetSales]
group by CustomerKey
order by "Sales per Customer" DESC

-- sales per customer of each territory
select CustomerKey,SalesTerritoryKey, sum(SalesAmount) As "Sales per Customer" from [dbo].[FactInternetSales]
group by CustomerKey, SalesTerritoryKey
order by "Sales per Customer" DESC

select CustomerKey,SalesAmount from [dbo].[FactInternetSales]
where CustomerKey = 11464


-- Analysis for [dbo].[FactResellerSales]

select * from [dbo].[FactResellerSales]

--Wrong use of where clause
select Distinct ProductKey,sum(SalesAmount) As SalesBYProduct from [dbo].[FactResellerSales]
where sum(SalesAmount) > 30000 AND OrderQuantity >= 5 
group by ProductKey, OrderQuantity


--Instead use having clause
-- correct result 
SELECT ProductKey, SUM(SalesAmount) AS SalesBYProduct
FROM [dbo].[FactResellerSales]
WHERE OrderQuantity > 5
GROUP BY ProductKey
HAVING SUM(SalesAmount) > 30000	

-- wrong result
SELECT ProductKey, SUM(SalesAmount) AS SalesBYProduct
FROM [dbo].[FactResellerSales]
GROUP BY ProductKey, OrderQuantity
HAVING SUM(SalesAmount) > 30000	AND OrderQuantity > 5
ORDER BY ProductKey ASC


-- Average Sales by Product
select ProductKey, avg(SalesAmount) As "Average Sales" from  [dbo].[FactResellerSales]
group by ProductKey
ORDER BY avg(SalesAmount) DESC

select ProductKey, avg(SalesAmount) As "Average Sales" from  [dbo].[FactResellerSales]
group by ProductKey
having avg(SalesAmount) > 5000
ORDER BY avg(SalesAmount) ASC

-- Total Orders by Product
select ProductKey, sum(OrderQuantity) AS "Total Order Quantity" from  [dbo].[FactResellerSales]
group by ProductKey
Order by ProductKey ASC

-- Sales by Employee
Select EmployeeKey,sum(SalesAmount) AS "Total Sales Per Employee" from [dbo].[FactResellerSales]
GROUP BY EmployeeKey
ORDER BY sum(SalesAmount) DESC


-- Sales by Territory
select SalesTerritoryKey, sum(SalesAmount) AS "Total Sales Per Employee" from [dbo].[FactResellerSales]
GROUP BY SalesTerritoryKey
ORDER BY SalesTerritoryKey ASC

-- Distinct Currency
select CurrencyKey, COUNT(CurrencyKey) AS "Most Used Currency" from [dbo].[FactResellerSales]
group by CurrencyKey
ORDER BY COUNT(CurrencyKey) ASC

-- Customer Sales
select CustomerPONumber, sum(SalesAmount) As "Sales per Customer" from [dbo].[FactResellerSales]
group by CustomerPONumber
ORDER BY sum(SalesAmount) DESC


-- same result with differnt query
-- query 1
select EmployeeKey, ProductKey from [dbo].[FactResellerSales]
where (EmployeeKey > 285 AND EmployeeKey < 290)
ORDER BY EmployeeKey ASC

-- query 2
select EmployeeKey, ProductKey from [dbo].[FactResellerSales]
where EmployeeKey Between 286 AND 289
ORDER BY EmployeeKey ASC


select * from [dbo].[DimProduct]
where EnglishProductName LIKE '%E'

select * from [dbo].[DimProduct]
where EnglishProductName LIKE 'A%'

select * from [dbo].[DimProduct]
where EnglishProductName NOT LIKE 'A%'

/* Inner Join */

select * from [dbo].[DimEmployee]
select * from [dbo].FactResellerSales

select Distinct(EmployeeKey) from dbo.FactResellerSales
select Distinct(DepartmentName) from dbo.DimEmployee

select EmployeeKey from dbo.DimEmployee
where DepartmentName = 'Sales'

-- INNER JOIN

-- Displaying Employee Name sales using inner join
SELECT Concat(DE.FirstName,' ',De.LastName) AS "Employee Name",DE.DepartmentName, SUM(FR.SalesAmount) AS "Total Sales Per Employee"
FROM
    [dbo].[FactResellerSales] FR
INNER JOIN
    [dbo].[DimEmployee] DE 
ON FR.EmployeeKey = DE.EmployeeKey
GROUP BY
    Concat(DE.FirstName,' ',De.LastName),
	DE.DepartmentName
ORDER BY
    SUM(FR.SalesAmount) DESC;


select * from [dbo].[DimProduct]
select Distinct(ProductKey) from dbo.DimProduct
select Distinct(ProductKey) from dbo.FactResellerSales
ORDER BY ProductKey ASC

-- Displaying the product name using inner join
-- right output
select P.EnglishProductName,FR.ProductKey, Sum(FR.SalesAmount) AS "Total Sales per Product"
from [dbo].FactResellerSales FR
INNER JOIN 
	[dbo].[DimProduct] P
ON FR.ProductKey = P.ProductKey
Group by 
Fr.ProductKey,
P.EnglishProductName
Order by 
Fr.ProductKey ASC,
Sum(FR.SalesAmount) DESC

-- wrong output
select P.EnglishProductName, Sum(FR.SalesAmount) AS "Total Sales per Product"
from [dbo].FactResellerSales FR
INNER JOIN 
	[dbo].[DimProduct] P
ON FR.ProductKey = P.ProductKey
Group by 
P.EnglishProductName
Order by 
Sum(FR.SalesAmount) DESC

--right output
select P.EnglishProductName, Sum(FR.SalesAmount) AS "Total Sales per Product"
from [dbo].FactResellerSales FR
INNER JOIN 
	[dbo].[DimProduct] P
ON FR.ProductKey = P.ProductKey
Group by 
P.EnglishProductName,
FR.ProductKey
Order by 
Sum(FR.SalesAmount) DESC

-- Displaying the top products with their orders using inner join
select P.EnglishProductName,sum(FR.OrderQuantity) As "Order Quantity" from dbo.FactResellerSales FR
INNER JOIN
dbo.DimProduct P
ON FR.ProductKey = P.ProductKey
group by
FR.ProductKey,
P.EnglishProductName
Order by
sum(FR.OrderQuantity) DESC

-- Displaying the sales of products using inner join
select P.EnglishProductName, sum(FR.OrderQuantity) AS "Total Order", sum(FR.SalesAmount) AS "Total Sales" from dbo.FactResellerSales FR
INNER JOIN dbo.DimProduct P
ON FR.ProductKey = P.ProductKey
Group by 
FR.ProductKey,
P.EnglishProductName
Order by 
[Total Sales] DESC

-- Displaying Sales per territory
select Tr.SalesTerritoryRegion, Tr.SalesTerritoryCountry, sum(FR.SalesAmount) AS "Sales Territory" from dbo.FactResellerSales FR
INNER JOIN dbo.DimSalesTerritory Tr
ON FR.SalesTerritoryKey = Tr.SalesTerritoryKey
Group by
Fr.SalesTerritoryKey,
Tr.SalesTerritoryRegion,
Tr.SalesTerritoryCountry

select Distinct(CustomerKey) from [dbo].[FactInternetSales]

-- Displaying Sales per Customer
select sum(FI.SalesAmount) AS "Total Sales", Concat(DC.FirstName, ' ', DC.LastName) AS "Customer Full Name" from [dbo].[FactInternetSales] FI
INNER JOIN dbo.DimCustomer DC
ON FI.CustomerKey = DC.CustomerKey
Group by 
FI.CustomerKey,
Concat(DC.FirstName, ' ', DC.LastName)
ORDER BY
Concat(DC.FirstName, ' ', DC.LastName) ASC

-- LEFT JOIN


-- RIGHT JOIN


SELECT Concat(DE.FirstName,' ',De.LastName) AS "Employee Name",DE.DepartmentName, SUM(FR.SalesAmount) AS "Total Sales Per Employee"
FROM
     [dbo].[FactResellerSales] FR
RIGHT JOIN
    [dbo].[DimEmployee] DE
ON FR.EmployeeKey = DE.EmployeeKey
GROUP BY
    Concat(DE.FirstName,' ',De.LastName),
	DE.DepartmentName
ORDER BY
    SUM(FR.SalesAmount) DESC;


