# Amazon DynamoDB — Create Table, Add Data, Query, and Delete

This lab covers the basics of a NoSQL database on AWS: creating a DynamoDB table, adding items with flexible (schema-less) attributes, modifying an item, querying data two different ways, and deleting the table.

## 1. Create a table

| Setting | Value |
|---|---|
| Table name | `Music` |
| Partition key | `Artist` (String) |
| Sort key | `Song` (String) |
| Indexes / capacity | Default settings |

The combination of partition key + sort key uniquely identifies each item in the table.

## 2. Add data

DynamoDB is schema-less beyond the primary key: each item can have its own set of attributes.

### Item 1

| Attribute | Type | Value |
|---|---|---|
| Artist | String | Pink Floyd |
| Song | String | Money |
| Album | String | The Dark Side of the Moon |
| Year | Number | 1973 |

### Item 2

| Attribute | Type | Value |
|---|---|---|
| Artist | String | John Lennon |
| Song | String | Imagine |
| Album | String | Imagine |
| Year | Number | 1971 |
| Genre | String | Soft Rock |

### Item 3

| Attribute | Type | Value |
|---|---|---|
| Artist | String | Psy |
| Song | String | Gangnam Style |
| Album | String | Psy 6 (Six Rules), Part 1 |
| Year | Number | 2011 |
| LengthSeconds | Number | 219 |

Note how each item has different attributes (`Genre`, `LengthSeconds`) beyond the required partition/sort keys — no table-wide schema is enforced.

## 3. Modify an existing item

- Go to **Explore items → Music**.
- Open the item where Artist = `Psy`, Song = `Gangnam Style`.
- Change `Year` from `2011` to `2012`.
- Save changes.

## 4. Query the table

There are two ways to retrieve data from DynamoDB:

### Query (uses the primary key — fast and efficient)

- Select **Query**.
- Partition key (Artist): `Psy`
- Sort key (Song): `Gangnam Style`
- Run.

Returns the single matching item almost instantly, since it's fully indexed.

### Scan (checks every item, then filters — slower on large tables)

- Select **Scan**.
- Expand **Filters**.
- Attribute name: `Year`, Type: `Number`, Value: `1971`
- Run.

Returns only the item matching the filter (John Lennon — Imagine), but the operation reads through every item in the table to find it.

## 5. Delete the table

- Go to **Tables**, select `Music`.
- Actions → Delete table.
- Type the confirmation word shown in the dialog (may be `delete` or `confirm` depending on console version) and confirm.

Deleting the table also permanently deletes all items inside it.

## Key concepts

- **Partition key**: determines how DynamoDB distributes data across storage partitions.
- **Sort key**: combined with the partition key, uniquely identifies each item and allows multiple items to share the same partition key.
- **Schema-less items**: only the key attributes are required; any other attributes can vary freely between items.
- **Query vs. Scan**: Query uses the primary key and is efficient; Scan reads the whole table and is less efficient, useful when filtering on non-key attributes.
