/*
Group: 44 - Rishi Patidar, Sayali Gurav
Course: IFT 530 Adv. DBMS
Description: Inventory Management System
SQL Server Version: MS SQL Server 2012 (SP1)
12/05/2024 Final Project.
*/

-- Create Database
--CREATE DATABASE Group44_InventoryDB;
USE Group44_InventoryDB

-- Creating Tables
-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT NOT NULL PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Address VARCHAR(255),
    Rating DECIMAL(3, 2) CHECK (Rating BETWEEN 0 AND 5)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT NOT NULL PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    BatchNumber VARCHAR(50),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10, 2) NOT NULL,
    ManufactureDate DATE NOT NULL,
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0),
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) 
);

-- Inventory Table
CREATE TABLE Inventory (
    InventoryID INT NOT NULL PRIMARY KEY,
    ProductID INT NOT NULL,
    Location VARCHAR(100) NOT NULL,
    ProductionQuantity INT NOT NULL CHECK (ProductionQuantity >= 0),
    InventoryTurnover DECIMAL(10, 2),
    SafetyStock INT,
    LastUpdateDate DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Contact VARCHAR(15) NOT NULL,
    PaymentDetails VARCHAR(50),
    Type VARCHAR(50) CHECK (Type IN ('Individual', 'Organization')) NOT NULL
);

-- Warehouse Table
CREATE TABLE Warehouse (
    WarehouseID INT NOT NULL PRIMARY KEY,
    Location VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    ManagerName VARCHAR(100) NOT NULL,
    Contact VARCHAR(15)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT NOT NULL PRIMARY KEY,
    ProductID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    ShippingAddress VARCHAR(255) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    CustomerID INT NOT NULL,
    ExpectedDeliveryDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Returns Table
CREATE TABLE Returns (
    ReturnID INT NOT NULL PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    ReasonForReturn VARCHAR(255) NOT NULL,
    ReturnDate DATE NOT NULL,
    RefundStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Shipping Table
CREATE TABLE Shipping (
    ShippingID INT NOT NULL PRIMARY KEY,
    OrderID INT NOT NULL,
    ShippingDate DATE NOT NULL,
    CarrierName VARCHAR(100) NOT NULL,
    TrackingNumber VARCHAR(50),
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Contact VARCHAR(15)
);

-- Populating Dimension Tables 
-- Populating Suppliers Table
INSERT INTO Suppliers (SupplierID, SupplierName, ContactNumber, Address, Rating)
VALUES
(101, 'Radio Shack', '9876543210', '123 Tech Lane', 4.7),
(102, 'Furniture Co.', '1234567890', '456 Furniture St.', 4.3),
(103, 'Best Buy', '1122334455', '789 Garden Ave.', 4.8),
(104, 'Office Supplies Inc.', '6677889900', '101 Office Way', 4.6),
(105, 'Target Essentials', '9988776655', '202 Myham Blvd.', 4.4),
(106, 'Tech Plus', '8877665544', '303 Tech Park', 4.2),
(107, 'Furniture Solutions', '7766554433', '404 Furniture Dr.', 4.1),
(108, 'Reliance Digital', '6655443322', '505 Digital Rd.', 4.5),
(109, 'Smart Living', '5544332211', '606 Smart Plaza', 4.0),
(110, 'Techmart', '4433221100', '707 Elite St.', 4.9);

-- Populating Products Table
INSERT INTO Products (ProductID, ProductName, BatchNumber, Category, UnitPrice, ManufactureDate, QuantityInStock, SupplierID)
VALUES
(1, 'Laptop', 'B001', 'Electronics', 1200.00, '2023-06-15', 50, 101),
(2, 'Smartphone', 'B002', 'Electronics', 800.00, '2023-08-01', 100, 102),
(3, 'Tablet', 'B003', 'Electronics', 399.99, '2023-09-01', 150, 103),
(4, 'Refrigerator', 'B004', 'Appliances', 700.00, '2023-05-01', 30, 104),
(5, 'Washing Machine', 'B005', 'Appliances', 600.00, '2023-04-01', 20, 105),
(6, 'Television', 'B006', 'Electronics', 1000.00, '2023-07-01', 40, 106),
(7, 'Microwave', 'B007', 'Appliances', 150.00, '2023-08-15', 70, 107),
(8, 'Blender', 'B008', 'Appliances', 50.00, '2023-03-01', 120, 108),
(9, 'Headphones', 'B009', 'Accessories', 80.00, '2023-09-20', 200, 109),
(10, 'Camera', 'B010', 'Electronics', 500.00, '2023-10-01', 25, 110);

-- Populating Inventory Table
INSERT INTO Inventory (InventoryID, ProductID, Location, ProductionQuantity, InventoryTurnover, SafetyStock, LastUpdateDate) 
VALUES
(11, 1, 'New York', 100, 10.5, 10, '2024-01-15'),
(12, 2, 'Los Angeles', 200, 12.3, 15, '2024-02-15'),
(13, 3, 'New York', 150, 9.8, 20, '2024-03-15'),
(14, 4, 'Chicago', 300, 11.4, 10, '2024-04-15'),
(15, 5, 'Los Angeles', 250, 8.7, 10, '2024-05-15'),
(16, 6, 'Chicago', 400, 13.2, 15, '2024-06-15'),
(17, 7, 'New York', 120, 7.9, 10, '2024-07-15'),
(18, 8, 'Los Angeles', 80, 6.5, 10, '2024-08-15'),
(19, 9, 'Chicago', 90, 14.1, 10, '2024-09-15'),
(20, 10, 'New York', 110, 15.0, 10, '2024-10-15');

--Populating Customer Table
INSERT INTO Customers (CustomerID, Name, Address, Contact, PaymentDetails, Type) 
VALUES
(1001, 'Tanjiro Kamado', 'Kamado Family Home, Mt. Sagiri', '1112223333', 'Credit Card', 'Individual'),
(1002, 'Nezuko Kamado', 'Kamado Family Home, Mt. Sagiri', '2223334444', 'PayPal', 'Individual'),
(1003, 'Zenitsu Agatsuma', 'Thunder Breathing Dojo, Natsu Village', '3334445555', 'Wire Transfer', 'Organization'),
(1004, 'Inosuke Hashibira', 'Boar’s Nest, Mt. Fujikawa', '4445556666', 'Credit Card', 'Organization'),
(1005, 'Kanao Tsuyuri', 'Butterfly Mansion, Wisteria Village', '5556667777', 'Cash', 'Individual'),
(1006, 'Giyu Tomioka', 'Water Pillar Estate, Demon Slayer Corps HQ', '6667778888', 'Check', 'Organization'),
(1007, 'Kanao Tsuyuri', 'Butterfly Mansion, Wisteria Village', '7778889999', 'Credit Card', 'Organization'),
(1008, 'Shinobu Kocho', 'Butterfly Mansion, Wisteria Village', '8889990000', 'PayPal', 'Individual'),
(1009, 'Muzan Kibutsuji', 'Eternal Night Mansion, Infinite City', '9990001111', 'Credit Card', 'Organization'),
(1010, 'Rui Williams', 'Demon’s Web, Forest of the Kizuki', '0001112222', 'Wire Transfer', 'Individual');

-- Populating Warehouse Table
INSERT INTO Warehouse (WarehouseID, Location, Capacity, ManagerName, Contact)
VALUES
(10, 'New York', 500, 'Sheldon Cooper', '9876543210'),
(20, 'Los Angeles', 750, 'Robert D. Junior', '1234567890'),
(30, 'Chicago', 600, 'Monkey D. Luffy', '1122334455'),
(40, 'Houston', 400, 'Portgus D. ACE', '6677889900'),
(50, 'Phoenix', 300, 'Gojo Saturo', '9988776655'),
(60, 'Philadelphia', 450, 'Franky Harris', '8877665544'),
(70, 'San Antonio', 500, 'Itachi Uchiha', '7766554433'),
(80, 'San Diego', 700, 'Hashirama Senju', '6655443322'),
(90, 'Dallas', 550, 'Kakshi Hatake', '5544332211'),
(100, 'San Jose', 650, 'Son Johnson', '4433221100');



--Populating Transactional Tables
-- Populating Orders Table
INSERT INTO Orders (OrderID, ProductID, OrderDate, Status, ShippingAddress, Amount, CustomerID, ExpectedDeliveryDate)
VALUES
(1, 1, '2024-01-15', 'Pending', '123 Main St.', 2400.00, 1001, '2024-01-20'),
(2, 2, '2024-01-16', 'Shipped', '456 Oak Rd.', 1600.00, 1002, '2024-01-22'),
(3, 3, '2024-01-17', 'Delivered', '789 Pine Ln.', 450.00, 1003, '2024-01-23'),
(4, 4, '2024-01-18', 'Cancelled', '101 Maple Dr.', 250.00, 1004, '2024-01-25'),
(5, 5, '2024-01-19', 'Pending', '202 Birch St.', 1200.00, 1005, '2024-01-27'),
(6, 6, '2024-01-20', 'Shipped', '303 Elm Ave.', 600.00, 1006, '2024-01-28'),
(7, 7, '2024-01-21', 'Delivered', '404 Spruce Ct.', 250.00, 1007, '2024-01-30'),
(8, 8, '2024-01-22', 'Pending', '505 Cedar Blvd.', 100.00, 1008, '2024-02-02'),
(9, 9, '2024-01-23', 'Shipped', '606 Walnut Way', 1050.00, 1009, '2024-02-05'),
(10, 10, '2024-01-24', 'Delivered', '707 Ash Trl.', 350.00, 1010, '2024-02-10'),
(11, 1, '2024-01-25', 'Pending', '808 Willow Rd.', 1200.00, 1001, '2024-02-12'),
(12, 2, '2024-01-26', 'Shipped', '909 Poplar St.', 800.00, 1002, '2024-02-15'),
(13, 3, '2024-01-27', 'Delivered', '1010 Beech Ave.', 450.00, 1003, '2024-02-18'),
(14, 4, '2024-01-28', 'Cancelled', '1111 Chestnut Pl.', 250.00, 1004, '2024-02-20'),
(15, 5, '2024-01-29', 'Pending', '1212 Redwood Dr.', 1200.00, 1005, '2024-02-22'),
(16, 6, '2024-01-30', 'Shipped', '1313 Cypress Ln.', 600.00, 1006, '2024-02-25'),
(17, 7, '2024-01-31', 'Delivered', '1414 Dogwood Ct.', 250.00, 1007, '2024-02-28'),
(18, 8, '2024-02-01', 'Pending', '1515 Magnolia Blvd.', 100.00, 1008, '2024-03-03'),
(19, 9, '2024-02-02', 'Shipped', '1616 Laurel Way.', 1050.00, 1009, '2024-03-06'),
(20, 10, '2024-02-03', 'Delivered', '1717 Juniper Trl.', 350.00, 1010, '2024-03-10');

-- Populating Returns Table
INSERT INTO Returns (ReturnID, OrderID, ProductID, ReasonForReturn, ReturnDate, RefundStatus) 
VALUES
(1010, 5, 5, 'Defective item', '2024-05-20', 'Approved'),
(1011, 9, 9, 'Wrong item', '2024-09-22', 'Pending'),
(1012, 13, 3, 'Item damaged during delivery', '2024-03-15', 'Approved'),
(1013, 8, 8, 'Incorrect item shipped', '2024-08-25', 'Pending'),
(1014, 4, 4, 'Not as described', '2024-04-30', 'Approved'),
(1015, 6, 6, 'Item missing parts', '2024-06-20', 'Approved'),
(1016, 7, 7, 'Duplicate order', '2024-07-25', 'Cancelled'),
(1017, 20, 10, 'Late delivery', '2024-10-10', 'Pending'),
(1018, 2, 2, 'Customer no longer needed', '2024-02-15', 'Cancelled'),
(1019, 11, 1, 'Packaging issue', '2024-01-28', 'Pending'),
(1020, 11, 1, 'Received wrong size', '2024-11-05', 'Pending'),
(1021, 2, 2, 'Color mismatch', '2024-11-10', 'Approved'),
(1022, 3, 3, 'Item not as per expectations', '2024-11-12', 'Cancelled'),
(1023, 14, 4, 'Arrived after event', '2024-11-18', 'Approved'),
(1024, 5, 5, 'Missing accessories', '2024-11-20', 'Pending'),
(1025, 16, 6, 'Item broke after one use', '2024-11-25', 'Approved'),
(1026, 7, 7, 'Not the model ordered', '2024-11-28', 'Cancelled'),
(1027, 8, 8, 'Wrong color delivered', '2024-12-01', 'Pending'),
(1028, 9, 9, 'Excessive wear and tear', '2024-12-03', 'Approved'),
(1029, 20, 10, 'Late shipping, customer lost interest', '2024-12-04', 'Cancelled');

-- Populating Shipping Table
INSERT INTO Shipping (ShippingID, OrderID, ShippingDate, CarrierName, TrackingNumber, Status) 
VALUES
(1111, 1, '2024-01-11', 'FedEx', 'FD1234567890', 'In Transit'),
(1112, 2, '2024-02-12', 'UPS', 'UP1234567890', 'Delivered'),
(1113, 3, '2024-03-13', 'DHL', 'DH1234567890', 'Shipped'),
(1114, 4, '2024-04-14', 'FedEx', 'FD9876543210', 'Pending'),
(1115, 5, '2024-05-15', 'UPS', 'UP9876543210', 'Cancelled'),
(1116, 6, '2024-06-16', 'DHL', 'DH9876543210', 'In Transit'),
(1117, 7, '2024-07-17', 'FedEx', 'FD4567891230', 'Delivered'),
(1118, 8, '2024-08-18', 'UPS', 'UP4567891230', 'Shipped'),
(1119, 9, '2024-09-19', 'DHL', 'DH4567891230', 'Pending'),
(1120, 10, '2024-10-20', 'FedEx', 'FD6547893210', 'In Transit'),
(1121, 11, '2024-11-21', 'UPS', 'UP6547891230', 'Delivered'),
(1122, 12, '2024-12-01', 'DHL', 'DH6547891230', 'Shipped'),
(1123, 13, '2024-12-05', 'FedEx', 'FD9876543210', 'Pending'),
(1124, 14, '2024-12-10', 'UPS', 'UP1230987654', 'In Transit'),
(1125, 15, '2024-12-12', 'DHL', 'DH3216549870', 'Delivered'),
(1126, 16, '2024-12-15', 'FedEx', 'FD2345678901', 'Shipped'),
(1127, 17, '2024-12-18', 'UPS', 'UP9872345678', 'Pending'),
(1128, 18, '2024-12-19', 'DHL', 'DH8765432109', 'In Transit'),
(1129, 19, '2024-12-21', 'FedEx', 'FD6541239876', 'Delivered'),
(1130, 20, '2024-12-23', 'UPS', 'UP3219876540', 'Cancelled');

-- Populating Employees Table
INSERT INTO Employees (EmployeeID, Name, Position, Contact) 
VALUES
(517, 'Naruto Uzumaki', 'Warehouse Manager', '1112223333'),
(861, 'Sasuke Uchiha', 'Inventory Specialist', '2223334444'),
(423, 'Sakura Haruno', 'Logistics Coordinator', '3334445555'),
(795, 'Kakashi Hatake', 'Shipping Manager', '4445556666'),
(672, 'Hinata Hyuga', 'Operations Manager', '5556667777'),
(104, 'Shikamaru Nara', 'Inventory Analyst', '6667778888'),
(506, 'Choji Akimichi', 'Supply Chain Manager', '7778889999'),
(342, 'Temari Nara', 'Warehouse Assistant', '8889990000'),
(910, 'Kiba Inuzuka', 'Returns Manager', '9990001111'),
(204, 'Tenten Li', 'Procurement Officer', '0001112222');