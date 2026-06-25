create database hotelcustomer;
use hotelcustomer;

show tables;

select * from customers;


SET SQL_SAFE_UPDATES = 0;

UPDATE customers
SET CustomerGender = CASE
    WHEN LOWER(CustomerGender) IN ('male', 'm') THEN 'Male'
    WHEN LOWER(CustomerGender) IN ('female', 'f') THEN 'Female'
    ELSE 'Other'
END;

select * from customers;

UPDATE customers
SET CustomerCountry = 'Unknown'
WHERE CustomerCountry IS NULL OR TRIM(CustomerCountry) = '';

UPDATE customers
SET CustomerCountry = 'Unknown'
WHERE CustomerCountry IS NULL OR TRIM(CustomerCountry) = '';

ALTER TABLE customers ADD AgeGroup VARCHAR(20);


ALTER TABLE customers 
ADD AgeGroup VARCHAR(20);

UPDATE customers
SET AgeGroup = CASE
    WHEN CustomerAge < 25 THEN 'Youth'
    WHEN CustomerAge BETWEEN 25 AND 44 THEN 'Adult'
    WHEN CustomerAge BETWEEN 45 AND 64 THEN 'Middle Age'
    ELSE 'Senior'
END;

select * from customers;

SELECT CustomerID, COUNT(*) AS DuplicateCount
FROM customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


DELETE FROM customers
WHERE CustomerAge < 0 OR CustomerAge > 120;


UPDATE customers
SET CustomerCountry = TRIM(CustomerCountry);

select * from customers;

UPDATE customers
SET CustomerCountry = 'Unknown'
WHERE CustomerCountry IS NULL 
   OR TRIM(CustomerCountry) = '';



SELECT DISTINCT CustomerCountry
FROM customers;




-- Aggreation And Analysis
-- Count customers per CustomerCountry(1)
SELECT CustomerCountry, COUNT(*) AS CustomerCount
FROM customers
GROUP BY CustomerCountry
ORDER BY CustomerCount DESC
limit 5;

-- Average age of customers grouped by CustomerGender(2)
SELECT CustomerGender, AVG(CustomerAge) AS AvgAge
FROM customers
GROUP BY CustomerGender;


-- Top 3 countries with the highest number of customers(3)
SELECT CustomerCountry, COUNT(*) AS CustomerCount
FROM customers
GROUP BY CustomerCountry
ORDER BY CustomerCount DESC
LIMIT 3;


-- Percentage of customers in each AgeGroup(4)
SELECT AgeGroup,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers) AS Percentage
FROM customers
GROUP BY AgeGroup;


-- Minimum and maximum customer ages per country(5)
SELECT CustomerCountry,
       MIN(CustomerAge) AS MinAge,
       MAX(CustomerAge) AS MaxAge
FROM customers
GROUP BY CustomerCountry;


-- rooms and pricing
-- Average BasePrice for each RoomType(6)
SELECT RoomType, AVG(BasePrice) AS AvgPrice
FROM rooms
GROUP BY RoomType;


-- Total capacity available across all rooms(7)
SELECT SUM(Capacity) AS TotalCapacity
FROM rooms;


-- List all rooms where Capacity >= 3(8)
SELECT RoomNumber, RoomType, Capacity
FROM rooms
WHERE Capacity >= 3;


-- Most expensive room type and its price(9)
SELECT RoomType, MAX(BasePrice) AS MaxPrice
FROM rooms
GROUP BY RoomType
ORDER BY MaxPrice DESC
LIMIT 1;


-- Revenue potential if all rooms are fully booked once (Capacity × BasePrice)(10)
SELECT SUM(Capacity * BasePrice) AS RevenuePotential
FROM rooms;





-- Show each booking with customer details and room type
SELECT o.OrderID, c.CustomerID, c.CustomerAge, c.CustomerGender, c.CustomerCountry,
       r.RoomType, r.BasePrice
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber;



-- Total revenue generated per RoomType:
SELECT r.RoomType, SUM(r.BasePrice) AS TotalRevenue
FROM orders o
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY r.RoomType
ORDER BY TotalRevenue DESC;

DESCRIBE orders;
SHOW COLUMNS FROM orders;


--  Country with the highest revenue potential:
SELECT c.CustomerCountry, SUM(r.BasePrice) AS CountryRevenue
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY c.CustomerCountry
ORDER BY CountryRevenue DESC
LIMIT 1;


-- Most popular room type overall
SELECT r.RoomType, COUNT(*) AS BookingCount
FROM orders o
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY r.RoomType
ORDER BY BookingCount DESC
LIMIT 1;


-- Most popular room type among customers under 30
SELECT r.RoomType, COUNT(*) AS BookingCount
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
WHERE c.CustomerAge < 30
GROUP BY r.RoomType
ORDER BY BookingCount DESC
LIMIT 1;



-- Percentage of bookings by gender
SELECT c.CustomerGender,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders) AS Percentage
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
GROUP BY c.CustomerGender;



-- Revenue per AgeGroup
SELECT c.AgeGroup, SUM(r.BasePrice) AS Revenue
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY c.AgeGroup
ORDER BY Revenue DESC;



-- Top 5 customers by total spend
SELECT c.CustomerID, c.CustomerCountry, SUM(r.BasePrice) AS TotalSpend
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY c.CustomerID, c.CustomerCountry
ORDER BY TotalSpend DESC
LIMIT 5;



-- Monthly revenue trend
SELECT MONTH(o.checkInDate) AS Month, SUM(r.BasePrice) AS MonthlyRevenue
FROM orders o
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY MONTH(o.checkInDate)
ORDER BY Month;



-- Countries booking the most Suites
SELECT c.CustomerCountry, COUNT(*) AS SuiteBookings
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
WHERE r.RoomType = 'Suite'
GROUP BY c.CustomerCountry
ORDER BY SuiteBookings DESC;



SELECT RoomType, AVG(BasePrice) AS AvgPrice
FROM rooms
GROUP BY RoomType;




SELECT SUM(Capacity) AS TotalCapacity
FROM rooms;
SELECT RoomNumber, RoomType, Capacity
FROM rooms
WHERE Capacity >= 3;


SELECT SUM(Capacity * BasePrice) AS RevenuePotential
FROM rooms;


SELECT c.CustomerCountry, c.AgeGroup,
       SUM(r.BasePrice) AS TotalRevenue
FROM orders o
JOIN customers c ON o.CustomerIDS = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY c.CustomerCountry, c.AgeGroup
ORDER BY TotalRevenue DESC
limit 6;


SELECT c.CustomerGender, c.AgeGroup, r.RoomType,
       COUNT(*) AS BookingCount
FROM orders o
JOIN customers c ON o.CustomerIDS = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY c.CustomerGender, c.AgeGroup, r.RoomType
ORDER BY BookingCount DESC
limit 5;


SELECT MONTH(o.CheckInDate) AS Month,
       SUM(r.BasePrice) AS MonthlyRevenue
FROM orders o
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY MONTH(o.CheckInDate)
ORDER BY Month
limit 6;





SELECT c.CustomerID, c.CustomerCountry,
       SUM(r.BasePrice) AS TotalSpend
FROM orders o
JOIN customers c ON o.CustomerIDs = c.CustomerID
JOIN rooms r ON o.RoomNumber = r.RoomNumber
GROUP BY c.CustomerID, c.CustomerCountry
ORDER BY TotalSpend DESC
LIMIT 5;






