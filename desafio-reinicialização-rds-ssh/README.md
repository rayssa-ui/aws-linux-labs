# RDS Challenge — Connect via SSH, Create Tables, and Join Data

This challenge covers launching an Amazon RDS database (Aurora or MySQL), connecting to it from a Linux server over SSH (key pair authentication, not Session Manager), creating two related tables, inserting sample data, and performing an INNER JOIN between them.

## 1. Launch the RDS database instance

Lab constraints:

| Setting | Value |
|---|---|
| Database engine | Amazon Aurora (Provisioned) or MySQL — Aurora Serverless not allowed |
| Template | Dev/Test or Free tier |
| Availability & durability | Avoid a standby instance |
| Instance size | Burstable classes — db.t*.micro to db.t*.medium |
| Storage | General Purpose SSD (gp2), up to 100 GB — no Provisioned IOPS |
| VPC | Lab VPC |
| Security group | Must allow the Linux server to reach the RDS instance on port 3306 |
| Enhanced monitoring (MySQL) | Disabled |
| Purchasing option | On-Demand only |

**Common pitfall:** the default lab security group (e.g. "Web Security Group") often only opens HTTP (80) and SSH (22) by default. Add an inbound rule for **MySQL/Aurora (port 3306)** from the Linux server's source, or the client will hang and eventually fail with:

```
ERROR 2003 (HY000): Can't connect to MySQL server on '<endpoint>' (110)
```

**Public access:** if creating the DB with public access enabled fails with an error about DNS resolution/hostnames in the VPC, set **Public access** to **No** — the lab VPC does not need to expose the DB publicly since the Linux server sits in the same VPC.

## 2. Connect to the Linux server via SSH

- Download the **PEM** (Linux/macOS) or **PPK** (Windows/PuTTY) key from the lab credentials panel.
- Note the Linux server's public IP address.
- Connect:
  - **PuTTY (Windows):** set Host Name to the server IP, load the `.ppk` file under Connection → SSH → Auth → Credentials, then log in as `ec2-user`.
  - **Linux/macOS:** `ssh -i key.pem ec2-user@<server-ip>`

## 3. Install a MySQL client and connect to the database

```bash
sudo yum install mariadb -y
```

Get the **Writer** endpoint from RDS → Databases → your cluster → Connectivity & security → Endpoints (use the one *without* `-ro-` in the name — that's the read-only replica endpoint).

```bash
mysql -u admin --password='<your_password>' -h <writer-endpoint>
```

See `commands.sql` for the full SQL used in this challenge.

## 4. Create and populate the tables

### RESTART table

| Column | Type |
|---|---|
| StudentID | INT (Primary Key) |
| StudentName | VARCHAR(100) |
| RestartCity | VARCHAR(100) |
| GraduationDate | DATETIME |

10 sample rows inserted.

### CLOUD_PRACTITIONER table

| Column | Type |
|---|---|
| StudentID | INT (Primary Key) |
| CertificationDate | DATETIME |

5 sample rows inserted, using StudentIDs that also exist in RESTART (1, 3, 5, 7, 9), so the join in the next step returns matching results.

## 5. Inner join

```sql
SELECT RESTART.StudentID, RESTART.StudentName, CLOUD_PRACTITIONER.CertificationDate
FROM RESTART
INNER JOIN CLOUD_PRACTITIONER ON RESTART.StudentID = CLOUD_PRACTITIONER.StudentID;
```

### Expected result

| StudentID | StudentName | CertificationDate |
|---|---|---|
| 1 | Ana Silva | 2024-04-01 10:00:00 |
| 3 | Carla Souza | 2024-04-15 11:00:00 |
| 5 | Eduarda Lima | 2024-07-10 09:30:00 |
| 7 | Gabriela Alves | 2024-10-01 15:00:00 |
| 9 | Isabela Rocha | 2024-11-20 13:45:00 |

Only students present in both tables (i.e., certified students) appear in the result — that's the nature of an INNER JOIN.

## Key concepts

- **PEM/PPK key authentication**: an alternative to Session Manager for SSH access; requires managing a private key file and opening port 22 in the security group.
- **Writer vs. Reader endpoint**: only the Writer endpoint accepts DDL/INSERT/UPDATE/DELETE operations.
- **Security group inbound rules**: control which sources can reach which ports; a missing rule for the DB port is a common cause of connection timeouts (not "access denied" — a true network-level block).
- **INNER JOIN**: returns only rows where the join condition matches in both tables — students without a certification date won't appear in the joined result.
