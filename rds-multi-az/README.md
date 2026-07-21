# Amazon RDS Multi-AZ Lab

Hands-on lab provisioning a highly available Amazon RDS for MySQL database in a Multi-AZ deployment, and connecting it to a web application (Address Book app) running on EC2.

## Objectives

- Create a security group to allow the web server to access the RDS instance
- Create a DB subnet group spanning two Availability Zones
- Provision a Multi-AZ Amazon RDS for MySQL instance
- Connect a web application to the RDS instance and persist data

## Environment

- **VPC:** Lab VPC (pre-existing, with public and private subnets across 2 AZs)
- **Compute:** EC2 instance running a web server (Address Book app)
- **Database:** Amazon RDS for MySQL — Multi-AZ (2 instances) deployment

## Steps

### 1. Create a security group for the RDS instance

- **Name:** `DB Security Group`
- **Description:** `Permit access from Web Security Group`
- **VPC:** `Lab VPC`
- **Inbound rule:** Type `MySQL/Aurora (3306)`, source set to the existing **Web Security Group** (custom source, not an IP range) — this allows only EC2 instances tied to the Web Security Group to reach the database on port 3306

### 2. Create a DB subnet group

- **Name:** `DB Subnet Group`
- **VPC:** `Lab VPC`
- **Availability Zones:** 1st and 2nd AZ in the list
- **Subnets:** `10.0.1.0/24` (Private Subnet 1) and `10.0.3.0/24` (Private Subnet 2)

A DB subnet group requires subnets across at least two AZs — this is what enables the Multi-AZ deployment underneath.

### 3. Create the RDS database instance

Key configuration choices (full/custom configuration, not "Easy create"):

| Setting | Value |
|---|---|
| Engine type | MySQL (not Aurora — Aurora creates a *cluster*, which requires different IAM permissions) |
| Template | Development/Test |
| Deployment option | Multi-AZ DB instance (2 instances) |
| DB instance identifier | `lab-db` |
| Master username | `main` |
| Credentials management | Self managed, password: `lab-password` |
| Instance class | Burstable classes (t) → `db.t3.medium` |
| Storage type | General Purpose SSD (gp3), 20 GiB allocated |
| Compute resource | Don't connect to an EC2 compute resource |
| VPC | Lab VPC |
| DB subnet group | DB Subnet Group |
| Public access | No |
| VPC security group | DB Security Group (existing) |
| Enhanced monitoring | Disabled |
| Performance Insights | Disabled |
| Initial database name | `lab` |
| Automated backups | Disabled (speeds up provisioning for lab purposes — not recommended for production) |

⚠️ **Gotcha:** the AWS console defaults to the **Aurora (MySQL-Compatible)** engine, which uses `rds:CreateDBCluster` instead of `rds:CreateDBInstance`. A lab IAM role scoped for RDS instances (not clusters) will fail with:
