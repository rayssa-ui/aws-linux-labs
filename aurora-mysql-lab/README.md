# Aurora MySQL — Create Instance, Connect via EC2, and Query Data

This lab covers creating an Amazon Aurora (MySQL Compatible) DB cluster, connecting to it from an EC2 instance via the MySQL client, and running basic SQL operations (create table, insert, select).

## 1. Create the Aurora DB cluster

Key configuration choices (Full configuration, not "Easy create"):

| Setting | Value |
|---|---|
| Engine type | Aurora (MySQL Compatible) |
| Engine version | Default for major version 8.0 |
| Template | Dev/Test |
| Cluster scalability type | Provisioned |
| Instance class | Burstable classes (t) → `db.t3.medium` |
| DB cluster identifier | `aurora` |
| Master username | `admin` |
| Credentials management | Self managed, password: `admin123` |
| Multi-AZ deployment | Don't create an Aurora Replica |
| Compute resource | Don't connect to an EC2 compute resource |
| VPC | LabVPC |
| DB subnet group | dbsubnetgroup |
| Public access | No |
| VPC security group | Choose existing → DBSecurityGroup (remove `default`) |
| Initial database name | `world` |
| Enhanced monitoring | Disabled |
| Encryption | Disabled |
| Auto minor version upgrade | Disabled |

After creation (~5 min), the cluster shows status **Available**.

## 2. Connect to the EC2 instance (Command Host)

1. Go to **EC2 → Instances**.
2. Select the **Command Host** instance.
3. Choose **Connect → Session Manager → Connect**.

This opens a browser-based terminal session on the instance — no SSH key required.

## 3. Configure the EC2 instance to connect to Aurora

Install
