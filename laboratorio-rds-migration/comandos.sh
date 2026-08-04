#!/bin/bash
# Comandos utilizados na migração do banco de dados do Café para o Amazon RDS

# ============================================
# Configuração da AWS CLI (host da CLI)
# ============================================
mkdir -p ~/.aws
# Credenciais coladas manualmente em ~/.aws/credentials, formato:
# [default]
# aws_access_key_id=...
# aws_secret_access_key=...
# aws_session_token=...

aws configure set region us-west-2
aws configure set output json
aws sts get-caller-identity

# ============================================
# Tarefa 2.3: Criação dos componentes pré-requisitos
# ============================================

# Security group para o banco de dados
aws ec2 create-security-group \
--group-name CafeDatabaseSG \
--description "Security group for Cafe database" \
--vpc-id vpc-05b1ed9818a5122e7
# GroupId retornado: sg-0de3bea9475352792

# Regra de entrada: permite MySQL (3306) apenas do security group da aplicação
aws ec2 authorize-security-group-ingress \
--group-id sg-0de3bea9475352792 \
--protocol tcp --port 3306 \
--source-group sg-056c2422877f40ca7

# Confirmação da regra
aws ec2 describe-security-groups \
--query "SecurityGroups[*].[GroupName,GroupId,IpPermissions]" \
--filters "Name=group-name,Values='CafeDatabaseSG'"

# Sub-rede privada 1 (mesma AZ da instância do café)
aws ec2 create-subnet \
--vpc-id vpc-05b1ed9818a5122e7 \
--cidr-block 10.200.2.0/23 \
--availability-zone us-west-2a
# SubnetId retornado: subnet-06c8fe63214a217b1

# Sub-rede privada 2 (AZ diferente)
aws ec2 create-subnet \
--vpc-id vpc-05b1ed9818a5122e7 \
--cidr-block 10.200.10.0/23 \
--availability-zone us-west-2b
# SubnetId retornado: subnet-0aff1cdb5a7537722

# Grupo de sub-redes do banco de dados
aws rds create-db-subnet-group \
--db-subnet-group-name "CafeDB Subnet Group" \
--db-subnet-group-description "DB subnet group for Cafe" \
--subnet-ids subnet-06c8fe63214a217b1 subnet-0aff1cdb5a7537722 \
--tags "Key=Name,Value=CafeDatabaseSubnetGroup"

# ============================================
# Tarefa 2.4: Criação da instância Amazon RDS MariaDB
# ============================================
# Observação: a versão 10.11.11 do laboratório original não estava disponível.
# Versão disponível mais próxima utilizada: 10.11.18

aws rds create-db-instance \
--db-instance-identifier CafeDBInstance \
--engine mariadb \
--engine-version 10.11.18 \
--db-instance-class db.t3.micro \
--allocated-storage 20 \
--availability-zone us-west-2a \
--db-subnet-group-name "CafeDB Subnet Group" \
--vpc-security-group-ids sg-0de3bea9475352792 \
--no-publicly-accessible \
--master-username root --master-user-password 'Re:Start!9'

# Monitorar status até "available"
aws rds describe-db-instances \
--db-instance-identifier CafeDBInstance \
--query "DBInstances[*].[Endpoint.Address,AvailabilityZone,PreferredBackupWindow,BackupRetentionPeriod,DBInstanceStatus]"
# Endpoint final: cafedbinstance.c5zrfye3fhw2.us-west-2.rds.amazonaws.com

# ============================================
# Tarefa 3: Migração dos dados (executado na CafeInstance)
# ============================================

# Backup do banco de dados local
mysqldump --user=root --password='Re:Start!9' \
--databases cafe_db --add-drop-database > cafedb-backup.sql

# Download do certificado SSL/TLS da AWS (necessário para conexão criptografada com RDS)
curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Restauração do backup no banco RDS
mysql --user=root --password='Re:Start!9' \
--host=cafedbinstance.c5zrfye3fhw2.us-west-2.rds.amazonaws.com \
--ssl-ca=./global-bundle.pem \
< cafedb-backup.sql

# Validação dos dados migrados
mysql --user=root --password='Re:Start!9' \
--host=cafedbinstance.c5zrfye3fhw2.us-west-2.rds.amazonaws.com \
--ssl-ca=./global-bundle.pem \
cafe_db
# Dentro do prompt MariaDB:
# select * from product;
# Resultado: 9 linhas retornadas (Croissant, Rosquinha, Cookie, Muffin,
# Tarte de Morango e Mirtilo, Tarte de Morango, Café, Chocolate Quente, Latte)
# exit

# ============================================
# Tarefa 4: Reconfiguração do parâmetro no Systems Manager
# ============================================
# Realizado via console: Systems Manager > Parameter Store > /cafe/dbUrl > Editar
# Valor atualizado para: cafedbinstance.c5zrfye3fhw2.us-west-2.rds.amazonaws.com
#
# NOTA: após essa alteração, o site retornou erro de autenticação
# ("Access denied for user 'cafedbinstance...'@...", usando o endpoint como
# se fosse o usuário). Indica que o valor colado no parâmetro pode ter incluído
# caracteres extras ou que o parâmetro correto para editar não era só o dbUrl.
# Pendência para investigação futura.
