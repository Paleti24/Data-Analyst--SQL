//sql queries//
SELECT * from Customers;
SELECT * from Orders;
SELECT * from Suppliers;

SELECT Country,CompanyName from Customers ORDER by Country ASC ,CompanyName ASC;

SELECT * from Orders order by OrderDate;

SELECT count(orderID) from Orders WHERE OrderDate=1997;

SELECT ContactName,ContactTitle FROM Suppliers where ContactTitle like '%manager%' ORDER by ContactName ASC;

SELECT * from orders WHERE OrderDate ='1997-05-19';

////joins/////
SELECT Orders.OrderID,
       Orders.OrderDate,
       Customers.CustomerID,
       Customers.ContactName
FROM Orders
JOIN Customers
  ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate = "1997"
ORDER BY Orders.OrderDate ASC;

SELECT c.City,
       COUNT(DISTINCT o.EmployeeID) AS EmployeeCount,
       COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Orders o
JOIN Customers c
  ON o.ShipCity = c.City
GROUP BY o.ShipCity
ORDER BY o.ShipCity ASC;

SELECT c.City,
       COUNT(DISTINCT o.EmployeeID) AS EmployeeCount,
       COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Customers c
LEFT JOIN Orders o
  ON c.City = o.ShipCity
GROUP BY c.City
ORDER BY c.City ASC;

SELECT COALESCE(o.ShipCity, c.City) AS City,
       COUNT(DISTINCT o.EmployeeID) AS EmployeeCount,
       COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Orders o
FULL OUTER JOIN Customers c
  ON o.ShipCity = c.City
GROUP BY COALESCE(o.ShipCity, c.City)
ORDER BY City ASC;

////Having////

SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(o.OrderID) AS LateOrders
FROM Orders o
JOIN Employees e
  ON o.EmployeeID = e.EmployeeID
WHERE o.ShippedDate > o.RequiredDate
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(o.OrderID) > 0
ORDER BY LateOrders DESC;

SELECT od.ProductID,
       SUM(od.Quantity) AS TotalQuantity
FROM Orders od
GROUP BY od.ProductID
HAVING SUM(od.Quantity) < 200
ORDER BY TotalQuantity ASC;

SELECT c.CustomerID,
       c.CompanyName,
       COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o
  ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1996-12-31'
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(o.OrderID) > 15
ORDER BY TotalOrders DESC;

////INSERT////
INSERT INTO Suppliers
    (SupplierID, CompanyName, ContactName, ContactTitle, Address, City, 
     Region, PostalCode, Country, Phone, Fax,HomePage)
VALUES
    ('30', 'Microsoft', 'Abhinaya', 'Data Analyst', 'Anantapur', 'Anantapur',
     'Andhra Pradesh', '515763', 'India', '9100078367', '(425) 555-1234', NULL);

INSERT INTO Orders
            (CustomerID,EmployeeID,OrderDate,RequiredDate)
VALUES
     ('ABHI','3','2026-09-08 05:40:51','2026-10-21 23:37:27');

INSERT INTO Customers
    (CustomerID, CompanyName, ContactName, City, Country)
VALUES
    (ANATR, AnaTrujilloEmparedadosyhelados, AnaTrujillo,México, Mexico);
	
	
	
UPDATE Customers
SET Phone='9876543210'
WHERE CustomerID='ANTON';

UPDATE Orders
SET Freight= Freight* 2
WHERE OrderID = 10248 AND CustomerID = 'VINET';

UPDATE Orders
SET Freight = Freight * 2
WHERE OrderID IN (
    SELECT OrderID
    FROM Orders
    WHERE CustomerID = 'TOMSP'
);

DELETE FROM Suppliers
WHERE SupplierID = 30 AND CompanyName = 'Microsoft';


SELECT ROUND(SUM(ShipVia * Freight * (1 - Freight-ShipVia)), 2) AS TotalRevenue1997
FROM Orders o
JOIN Customers c ON o.OrderID = c.CustomerID
WHERE strftime('%Y', o.OrderDate) = '1997';

SELECT c.CustomerID, c.CompanyName,
       ROUND(SUM(o.ShipVia * o.Freight * (1 - o.Freight-ShipVia)), 2) AS TotalPaid
FROM Customers c
JOIN Suppliers s ON s.SupplierID = s.SupplierID
JOIN Orders o ON o.OrderID = o.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalPaid DESC;

SELECT c.ContactName,
       ROUND(SUM(o.ShipVia* o.Freight * (1 - o.Freight-o.ShipVia)), 2) AS TotalSales
FROM Customers c
JOIN Orders o ON c.CustomerID = o.OrderID
GROUP BY c.ContactName
ORDER BY TotalSales DESC
LIMIT 10;

CREATE VIEW CustomerRevenues AS
SELECT c.CustomerID, c.CompanyName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName;

SELECT c.CustomerID, c.CompanyName, c.Country,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalPaid
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
WHERE c.Country = 'UK'
GROUP BY c.CustomerID, c.CompanyName, c.Country
HAVING TotalPaid > 1000;

SELECT c.CustomerID, c.CompanyName, c.Country,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalOverall,
       ROUND(SUM(CASE WHEN strftime('%Y', o.OrderDate) = '1997'
                      THEN od.UnitPrice * od.Quantity * (1 - od.Discount)
                      ELSE 0 END), 2) AS Total1997
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName, c.Country
ORDER BY TotalOverall DESC;


			

	 







