# Hospedagem de Site Estático no Amazon S3

Este laboratório aborda a criação de um bucket S3, configuração de permissões públicas, upload de um site estático e criação de um script de deploy repetível.

## 1. Conectar à instância EC2 via SSM
Conexão feita pelo AWS Systems Manager Session Manager, trocando para o usuário ec2-user.

## 2. Configurar a AWS CLI
Configuração das credenciais (Access Key, Secret Key, região us-west-2, formato json) com `aws configure`.

## 3. Criar bucket S3
Criação de um bucket na região us-west-2 usando `aws s3api create-bucket`.

## 4. Criar usuário IAM com acesso total ao S3
Criação do usuário `awsS3user`, perfil de login e anexação da política `AmazonS3FullAccess`.

## 5. Ajustar permissões do bucket
Desativação do bloqueio de acesso público e ativação de ACLs no bucket.

## 6. Upload dos arquivos do site
Upload dos arquivos (`index.html`, `css`, `images`) para o bucket usando `aws s3 cp --recursive --acl public-read`, e ativação da hospedagem de site estático com `aws s3 website`.

## 7. Script de deploy repetível
Criação do script `update-website.sh`, que automatiza o upload dos arquivos do site para o S3.

## Desafio opcional
Substituição do comando `aws s3 cp` por `aws s3 sync`, que envia apenas os arquivos novos ou modificados, tornando o deploy mais eficiente.
