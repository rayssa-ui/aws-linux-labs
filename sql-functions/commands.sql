-- ============================================
-- Lab: SQL Functions (Aggregate & String)
-- Database engine: MySQL / MariaDB
-- Database: world
-- ============================================

-- Task 1: Connect to the database
-- (run in terminal, not in SQL shell)
-- mysql -u root --password='re:St@rt!9'

-- ============================================
-- Task 2: Query the world database with functions
-- ============================================

-- Show existing databases
SHOW DATABASES;

-- Review table schema, data, and row count
SELECT * FROM world.country;

-- Aggregate functions: SUM, AVG, MAX, MIN, COUNT
SELECT sum(Population), avg(Population), max(Population), min(Population), count(Population)
FROM world.country;

-- Split a string using SUBSTRING_INDEX (first word of Region)
SELECT Region, substring_index(Region, " ", 1) FROM world.country;

-- Use SUBSTRING_INDEX inside a WHERE clause
SELECT Name, Region FROM world.country
WHERE substring_index(Region, " ", 1) = "Southern";

-- Use LENGTH + TRIM to find regions with short names
SELECT Region FROM world.country
WHERE LENGTH(TRIM(Region)) < 10;

-- Remove duplicates using DISTINCT
SELECT DISTINCT(Region) FROM world.country
WHERE LENGTH(TRIM(Region)) < 10;

-- ============================================
-- Challenge: Split "Micronesia/Caribbean" into
-- two separate columns
-- ============================================
SELECT
  SUBSTRING_INDEX(Region, "/", 1) as "Region Name 1",
  SUBSTRING_INDEX(Region, "/", -1) as "Region Name 2"
FROM world.country
WHERE Region = "Micronesia/Caribbean";
