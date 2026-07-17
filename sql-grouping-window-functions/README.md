# SQL Grouping & Window Functions Lab

Hands-on lab practicing data aggregation and window functions in MySQL/MariaDB using `GROUP BY` and the `OVER()` clause, on an AWS EC2 instance (Command Host) connected via AWS Session Manager.

## Objectives

- Use the `GROUP BY` clause with the aggregate function `SUM()`
- Use the `OVER` clause with the `RANK()` window function
- Use the `OVER` clause with the aggregate function `SUM()` and the `RANK()` window function

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

### 2. Query the world database

- Verified the `world` database exists and reviewed the `country` table
- Filtered and sorted records for "Australia and New Zealand" using `WHERE` + `ORDER BY`
- Used `GROUP BY` + `SUM()` to collapse all matching records into a single total population value
- Used a **window function** (`SUM() OVER(PARTITION BY Region ORDER BY Population)`) to calculate a running total **without collapsing** individual rows
- Added `RANK() OVER(PARTITION BY Region ORDER BY Population)` to assign a position/rank to each country within its region

### Key difference: `GROUP BY` vs `OVER()`

- `GROUP BY` returns **one summary row per group** (rows are collapsed)
- `OVER()` (window function) returns **every original row**, with an extra calculated column based on its group — nothing is collapsed

### 3. Challenge — Rank countries in every region by population (largest to smallest)

```sql
SELECT Region, Name, Population,
RANK() OVER(PARTITION BY Region ORDER BY Population DESC) as 'Ranked'
FROM world.country;
```

Since the goal was to rank every individual country (not summarize), `OVER()` + `RANK()` was the right choice — `GROUP BY` would have collapsed the results, and `SUM()` would have aggregated instead of ranked.

## Key takeaways

| Clause / Function | Purpose |
|---|---|
| `ORDER BY` | Sorts the result set |
| `GROUP BY` | Groups rows and collapses them into one row per group |
| `OVER(PARTITION BY ...)` | Applies a function "per group" **without collapsing** rows |
| `SUM() OVER()` | Running total per partition |
| `RANK() OVER()` | Assigns a rank/position within each partition |

All SQL commands used in this lab are available in [`commands.sql`](./commands.sql).
