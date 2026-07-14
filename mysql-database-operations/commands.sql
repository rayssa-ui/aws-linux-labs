-- ============================================
-- Lab: Common Database and Table Operations
-- Database engine: MySQL / MariaDB
-- ============================================

-- Task 1: Connect to the database
-- (run in terminal, not in SQL shell)
-- mysql -u root --password='re:St@rt!9'

-- ============================================
-- Task 2: Create a database and a table
-- ============================================

-- Show existing databases
SHOW DATABASES;

-- Create a new database named world
CREATE DATABASE world;

-- Verify the database was created
SHOW DATABASES;

-- Create the country table
CREATE TABLE world.country (
  `Code` CHAR(3) NOT NULL DEFAULT '',
  `Name` CHAR(52) NOT NULL DEFAULT '',
  `Conitinent` enum('Asia','Europe','North America','Africa','Oceania','Antarctica','South  America') NOT NULL DEFAULT 'Asia',
  `Region` CHAR(26) NOT NULL DEFAULT '',
  `SurfaceArea` FLOAT(10,2) NOT NULL DEFAULT '0.00',
  `IndepYear` SMALLINT(6) DEFAULT NULL,
  `Population` INT(11) NOT NULL DEFAULT '0',
  `LifeExpectancy` FLOAT(3,1) DEFAULT NULL,
  `GNP` FLOAT(10,2) DEFAULT NULL,
  `GNPOld` FLOAT(10,2) DEFAULT NULL,
  `LocalName` CHAR(45) NOT NULL DEFAULT '',
  `GovernmentForm` CHAR(45) NOT NULL DEFAULT '',
  `HeadOfState` CHAR(60) DEFAULT NULL,
  `Capital` INT(11) DEFAULT NULL,
  `Code2` CHAR(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`Code`)
);

-- Verify the table exists
USE world;
SHOW TABLES;

-- List all columns and their properties
SHOW COLUMNS FROM world.country;

-- Fix the misspelled "Conitinent" column
ALTER TABLE world.country RENAME COLUMN Conitinent TO Continent;

-- Verify the column name was corrected
SHOW COLUMNS FROM world.country;

-- ============================================
-- Challenge 1: Create a "city" table
-- with Name and Region columns (CHAR type)
-- ============================================
CREATE TABLE world.city (
  `Name` CHAR(50) NOT NULL DEFAULT '',
  `Region` CHAR(26) NOT NULL DEFAULT ''
);

-- ============================================
-- Task 3: Delete a database and tables
-- ============================================

-- Drop the city table
DROP TABLE world.city;

-- Challenge 2: Drop the country table
DROP TABLE world.country;

-- Verify both tables were dropped
SHOW TABLES;

-- Drop the world database
DROP DATABASE world;

-- Verify the database was deleted
SHOW DATABASES;
