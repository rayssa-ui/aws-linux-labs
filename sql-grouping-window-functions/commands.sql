-- ============================================
-- Lab: SQL Grouping & Window Functions
-- Database engine: MySQL / MariaDB
-- Database: world
-- ============================================

-- Task 1: Connect to the database
-- (run in terminal, not in SQL shell)
-- mysql -u root --password='re:St@rt!9'

-- ============================================
-- Task 2: Query the world database
-- ============================================

-- Show existing databases
SHOW DATABASES;

-- Review table schema, data, and row count
SELECT * FROM world.country;

-- Filter and sort records with ORDER BY
SELECT Region, Name, Population
FROM world.country
WHERE Region = 'Australia and New Zealand'
ORDER By Population desc;

-- Group records with GROUP BY + SUM (collapses into one row)
SELECT Region, SUM(Population)
FROM world.country
WHERE Region = 'Australia and New Zealand'
GROUP By Region
ORDER By SUM(Population) desc;

-- Running total using a window function (OVER) - keeps every row
SELECT Region, Name, Population,
SUM(Population) OVER(partition by Region ORDER BY Population) as 'Running Total'
FROM world.country
WHERE Region = 'Australia and New Zealand';

-- Add RANK() to show position within the region
SELECT Region, Name, Population,
SUM(Population) OVER(partition by Region ORDER BY Population) as 'Running Total',
RANK() over(partition by region ORDER BY population) as 'Ranked'
FROM world.country
WHERE region = 'Australia and New Zealand';

-- ============================================
-- Challenge: Rank countries in every region
-- by population, largest to smallest
-- ============================================
SELECT Region, Name, Population,
RANK() OVER(PARTITION BY Region ORDER BY Population DESC) as 'Ranked'
FROM world.country;
