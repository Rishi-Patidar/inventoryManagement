/*
Description: Inventory Management System
SQL Server Version: MS SQL Server 2012 (SP1)
*/
USE Group44_InventoryDB
Go
/*
Question 1.
Creating three queries and converting them into views. 
All queries must be joined to one or more tables. 
Make sure to restrict the data by using a where clause for each of the queries
*/
-- Query 1
CREATE VIEW LowStockProducts AS
SELECT p.ProductName, p.QuantityInStock, s.SupplierName, s.ContactNumber
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.QuantityInStock < 50;
-- Test Query
SELECT * FROM LowStockProducts;

--Query 2
CREATE VIEW PendingOrders AS
SELECT o.OrderID, o.Status AS OrderStatus, s.Status AS ShippingStatus, s.CarrierName, s.TrackingNumber
FROM Orders o
JOIN Shipping s ON o.OrderID = s.OrderID
WHERE o.Status = 'Pending';
-- Test Query
SELECT * FROM PendingOrders;

-- Query 3
CREATE VIEW CustomerOrdersSummary AS
SELECT c.Name AS CustomerName, COUNT(o.OrderID) AS TotalOrders, SUM(o.Amount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;
-- Test Query
SELECT * FROM CustomerOrdersSummary;
/*
Question 2.
Create an audit table for one of the lookup tables and demonstrate data saved to that audit table when data in the original table is inserted, 
modified, or deleted. Include an additional column in the audit table that will have a datetime field when the data was changed in the original table. 
Include the script to test all the operations
*/
-- AUDIT TABLE 
-- Creating Audit Table
CREATE TABLE AuditSuppliers (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    OperationType VARCHAR(10) NOT NULL CHECK (OperationType IN ('INSERT', 'UPDATE', 'DELETE')),
    ChangeDateTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Creating Audit Trigger
CREATE TRIGGER trg_AuditSuppliers
ON Suppliers
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Log INSERT operations
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO AuditSuppliers (SupplierID, OperationType)
        SELECT SupplierID, 'INSERT'
        FROM INSERTED;
    END

    -- Log UPDATE operations
    IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO AuditSuppliers (SupplierID, OperationType)
        SELECT SupplierID, 'UPDATE'
        FROM INSERTED;
    END

    -- Log DELETE operations
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO AuditSuppliers (SupplierID, OperationType)
        SELECT SupplierID, 'DELETE'
        FROM DELETED;
    END
END;

-- Testing query
INSERT INTO Suppliers (SupplierID, SupplierName, ContactNumber, Address, Rating)
VALUES (101, 'Radio Shack', '9876543210', '123 Tech Lane', 4.7);


UPDATE Suppliers
SET Rating = 4.8
WHERE SupplierID = 105;

DELETE FROM Suppliers
WHERE SupplierID = 102;
-- Result Query
SELECT * FROM AuditSuppliers;
SELECT * FROM Suppliers;

/*
Question 3.
Demonstrate a use of the one stored procedures and User Defined Function (UDF) for your database.
Include create and drop scripts
*/

-- Stored Procedures and UDF
-- Stored Procedure
CREATE PROCEDURE RestockInventory
AS
BEGIN
    -- Update products with low inventory
    UPDATE Inventory
    SET ProductionQuantity = ProductionQuantity + 100
    WHERE ProductionQuantity < 150;
END;
GO
-- Calling the stored procedure
EXEC RestockInventory;
Select * From Inventory
-- Dropping Stored procedure
DROP PROCEDURE RestockInventory;


-- User Defined Function (UDF)
-- Create the function
CREATE FUNCTION TotalSpentByCustomer (@custID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalAmount DECIMAL(10, 2);

    -- Calculate the total amount spent by the customer
    SELECT @TotalAmount = SUM(Amount)
    FROM Orders
    WHERE CustomerID = @custID;

    RETURN @TotalAmount;
END;
GO

-- Call the function
SELECT dbo.TotalSpentByCustomer(1006) AS TotalSpent; 

-- Dropping the Fuction
DROP FUNCTION dbo.TotalSpentByCustomer;
GO

/*
Question 4.
Demonstrating the use of one cursor for your database. Create and drop script for cursor
*/

-- Demonstrating Cursor
CREATE PROCEDURE ProcessLowStockProducts
AS
BEGIN
    -- Declare variables for cursor processing
    DECLARE @prod_name VARCHAR(100);

    -- Declare cursor for low stock products
    DECLARE product_cursor CURSOR FOR 
    SELECT ProductName FROM Products WHERE QuantityInStock < 50;

    -- Open the cursor
    OPEN product_cursor;

    -- Fetch the first product
    FETCH NEXT FROM product_cursor INTO @prod_name;

    -- Process each row in the cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Print message for each product with low stock
        PRINT CONCAT('Low Stock Alert: ', @prod_name);

        -- Fetch the next product
        FETCH NEXT FROM product_cursor INTO @prod_name;
    END;

    -- Close and deallocate the cursor
    CLOSE product_cursor;
    DEALLOCATE product_cursor;
END;

-- Executing Cursor Procedure
EXEC ProcessLowStockProducts;

-- Dropping Cursor Procedure
DROP PROCEDURE ProcessLowStockProducts;