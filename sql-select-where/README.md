# SQL SELECT & WHERE Filtering Lab

Hands-on lab practicing conditional filtering in MySQL/MariaDB using the `SELECT` statement and `WHERE` clause, on an AWS EC2 instance (Command Host) connected via AWS Session Manager.

## Objectives

- Write a search condition using the `WHERE` clause
- Use the `BETWEEN` operator
- Use the `LIKE` operator with wildcard characters
- Use the `AS` operator to create a column alias
- Use functions in a `SELECT` statement
- Use functions in a `WHERE` clause

## Environment

- **Compute:** Amazon EC2 instance ("Command Host") with a MySQL client pre-installed
- **Connection method:** AWS Systems Manager Session Manager
- **Database:** `world` (pre-loaded, contains 3 tables)

## Steps

### 1. Connect to the Command Host

```bash
sudo su
cd /home/ec2-user/
mysql -u root --password='re:St@rt!9'
```

### 2. Query the world database

- Verified the `world` database exists with `SHOW DATABASES;`
- Viewed the full `country` table with `SELECT * FROM world.country;`
- Filtered records by population range using `WHERE ... AND`
- Rewrote the same filter using `BETWEEN` (more readable, inclusive range)
- Used `LIKE` with the `%` wildcard to match countries where `Region` contains "Europe"
- Combined `LIKE` with `SUM()` to aggregate the total population of Europe
- Used `AS` to create a readable column alias for the aggregated result
- Used `LOWER()` in the `WHERE` clause to perform a case-insensitive search

### 3. Challenge — Sum of area and population for North America

```sql
SELECT sum(SurfaceArea) as "Total Area", sum(Population) as "Total Population"
FROM world.country
WHERE Region LIKE "%North America%";
```

**Result:**

| Total Area | Total Population |
|---|---|
| 21,500,515.00 | 309,632,000 |

## Key takeaways

| Concept | Purpose |
|---|---|
| `WHERE` | Filters records by condition |
| `AND` | Combines multiple conditions |
| `BETWEEN` | Filters by inclusive range — more readable than `>=` + `<=` |
| `LIKE` + `%` | Pattern matching (wildcard search) |
| `AS` | Creates a column alias |
| `SUM()` | Aggregate function |
| `LOWER()` | Converts text to lowercase — useful for case-insensitive searches |

All SQL commands used in this lab are available in [`commands.sql`](./commands.sql).
