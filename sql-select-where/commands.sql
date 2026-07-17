-- ============================================
-- Lab: SQL SELECT & WHERE Filtering
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

-- View the full country table
SELECT * FROM world.country;

-- Filter records using WHERE + AND
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE Population >= 50000000 AND Population <= 100000000;

-- Same filter, rewritten with BETWEEN (more readable, inclusive)
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE Population BETWEEN 50000000 AND 100000000;

-- Use LIKE with wildcard (%) + SUM to get total population of Europe
SELECT sum(Population)
FROM world.country
WHERE Region LIKE "%Europe%";

-- Same query, with a column alias using AS
SELECT sum(population) as "Total da População da Europa"
FROM world.country
WHERE region LIKE "%Europe%";

-- Case-insensitive search using LOWER()
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE LOWER(Region) LIKE "%central%";

-- ============================================
-- Challenge: Sum of surface area and population
-- for North America
-- ============================================
SELECT sum(SurfaceArea) as "Total Area", sum(Population) as "Total Population"
FROM world.country
WHERE Region LIKE "%North America%";

-- Result:
-- Total Area: 21500515.00
-- Total Population: 309632000
