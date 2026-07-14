# MySQL Database & Table Operations Lab

Hands-on lab practicing common MySQL/MariaDB database and table operations on an AWS EC2 instance (Command Host), connected via AWS Session Manager.

## Objectives

- Use `CREATE` to create databases and tables
- Use `SHOW` to view available databases and tables
- Use `ALTER` to modify a table's structure
- Use `DROP` to delete databases and tables

## Environment

- **Compute:** Amazon EC2 instance ("Command Host") with a MySQL client pre-installed
- **Connection method:** AWS Systems Manager Session Manager (no SSH key needed)
- **Database engine:** MariaDB

## Steps

### 1. Connect to the Command Host

Connected to the EC2 instance via **EC2 → Instances → Command Host → Connect → Session Manager**, then prepared the shell:

```bash
sudo su
cd /home/ec2-user/
mysql -u root --password='re:St@rt!9'
```

### 2. Create a database and a table

- Created a `world` database
- Created a `country` table with 15 columns (`Code`, `Name`, `Continent`, `Region`, `Population`, etc.)
- Used `SHOW COLUMNS` to inspect the table schema
- Found a typo in the schema (`Conitinent` instead of `Continent`) and fixed it with:

```sql
ALTER TABLE world.country RENAME COLUMN Conitinent TO Continent;
```

### 3. Challenge 1 — Create a `city` table

Created a `city` table with two `CHAR` columns: `Name` and `Region`.

### 4. Delete tables and database

- Dropped the `city` table
- **Challenge 2:** wrote and ran the query to drop the `country` table
- Dropped the `world` database entirely
- Verified deletion with `SHOW DATABASES;` — only the default system schemas remained (`information_schema`, `mysql`, `performance_schema`)

## Key takeaways

| Command | Purpose |
|---|---|
| `CREATE DATABASE` / `CREATE TABLE` | Create new databases and tables |
| `SHOW DATABASES` / `SHOW TABLES` / `SHOW COLUMNS` | Inspect existing structures |
| `ALTER TABLE ... RENAME COLUMN` | Modify table schema |
| `DROP TABLE` / `DROP DATABASE` | Permanently delete tables/databases |

All SQL commands used in this lab are available in [`commands.sql`](./commands.sql).
