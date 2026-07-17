# SQL Functions Lab (Aggregate & String Functions)

Hands-on lab practicing SQL functions in `SELECT` statements and `WHERE` clauses using MySQL/MariaDB, on an AWS EC2 instance (Command Host) connected via AWS Session Manager.

## Objectives

- Use aggregate functions `SUM()`, `MIN()`, `MAX()`, and `AVG()` to summarize data
- Use `SUBSTRING_INDEX()` to split strings
- Use `LENGTH()` and `TRIM()` to determine the length of a string
- Use `DISTINCT()` to filter duplicate records
- Use functions inside a `SELECT` statement and a `WHERE` clause

## Environment

- **Compute:** Amazon EC2 instance ("Command Host") with a MySQL client pre-installed
- **Connection method:** AWS Systems Manager Session Manager
- **Database:** `world` (pre-loaded, contains the `country` table)

## Steps

### 1. Connect to the Command Host

```bash
sudo su
cd /home/ec2-user/
mysql -u root --password='re:St@rt!9'
```

### 2. Query the world database with functions

- Verified the `world` database exists and reviewed the `country` table schema/data
- Used aggregate functions in a single query to summarize the entire `Population` column:
  - `SUM()` — total population
  - `AVG()` — average population
  - `MAX()` / `MIN()` — highest/lowest population
  - `COUNT()` — number of rows with a population value
- Used `SUBSTRING_INDEX(Region, " ", 1)` to extract the first word of each region name
- Used the same function inside a `WHERE` clause to filter regions starting with "Southern"
- Used `LENGTH(TRIM(Region)) < 10` to find regions with short names (trimming whitespace first)
- Used `DISTINCT()` to remove duplicate region names from the result

### 3. Challenge — Split "Micronesia/Caribbean" into two columns

```sql
SELECT 
  SUBSTRING_INDEX(Region, "/", 1) as "Region Name 1", 
  SUBSTRING_INDEX(Region, "/", -1) as "Region Name 2"
FROM world.country 
WHERE Region = "Micronesia/Caribbean";
```

`SUBSTRING_INDEX(Region, "/", 1)` returns everything before the first `/` (Micronesia), while `SUBSTRING_INDEX(Region, "/", -1)` returns everything after the last `/` (Caribbean) — the negative count counts delimiters from the end of the string.

## Key takeaways

| Function | Purpose |
|---|---|
| `SUM()`, `AVG()`, `MAX()`, `MIN()`, `COUNT()` | Aggregate functions — summarize data across multiple rows |
| `SUBSTRING_INDEX(str, delim, count)` | Splits a string by a delimiter |
| `LENGTH()` | Counts characters in a string |
| `TRIM()` | Removes leading/trailing whitespace |
| `DISTINCT()` | Removes duplicate values from the result set |

All SQL commands used in this lab are available in [`commands.sql`](./commands.sql).
