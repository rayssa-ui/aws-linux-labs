# =========================================================
# Laboratório: Investigação CloudTrail - Ataque ao Café
# Comandos utilizados do início ao fim
# =========================================================

# Conectar via SSH ao servidor (executado localmente, fora da instância)
# ssh -i labsuser.pem ec2-user@<ip-publico>

# ---------------------------------------------------------
# Baixar e extrair os logs do CloudTrail
# ---------------------------------------------------------

mkdir ctraillogs
cd ctraillogs

# Listar buckets S3 disponíveis para confirmar o nome do bucket de logs
aws s3 ls

# Baixar todos os logs do bucket do CloudTrail
aws s3 cp s3://monitoring-rayssa-58291/ . --recursive

# Navegar até a pasta com os arquivos de log do dia
cd AWSLogs/744639450388/CloudTrail/us-west-2/2026/08/13

# Extrair os arquivos compactados
gunzip *.gz


# ---------------------------------------------------------
# Explorar a estrutura dos logs e localizar o evento suspeito com grep
# ---------------------------------------------------------

# Ver conteúdo bruto de um log
cat <nome_do_arquivo.json>

# Ver conteúdo formatado (mais legível)
cat <nome_do_arquivo.json> | python -m json.tool

# Definir IP do servidor como variável para facilitar buscas
ip=34.219.79.222

# Buscar todos os IPs de origem em todos os arquivos
for i in $(ls); do echo $i && cat $i | python -m json.tool | grep sourceIPAddress ; done

# Buscar todos os nomes de evento em todos os arquivos
for i in $(ls); do echo $i && cat $i | python -m json.tool | grep eventName ; done

# Buscar diretamente o evento de abertura de porta no security group
grep -l "AuthorizeSecurityGroupIngress" *.json

# Ver contexto completo do evento encontrado
grep -B 5 -A 30 "AuthorizeSecurityGroupIngress" *.json


# ---------------------------------------------------------
# Confirmar a investigação usando a AWS CLI
# ---------------------------------------------------------

# Verificar se houve logins pelo console
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin

# Buscar todas as ações realizadas em Security Groups
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceType,AttributeValue=AWS::EC2::SecurityGroup --output text

# Obter automaticamente a região e o ID do security group do servidor Café
region=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | cut -d '"' -f4)
sgId=$(aws ec2 describe-instances --filters "Name=tag:Name,Values='Cafe Web Server'" --query 'Reservations[*].Instances[*].SecurityGroups[*].[GroupId]' --region $region --output text)
echo $sgId

# Filtrar eventos apenas do security group do servidor Café
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceType,AttributeValue=AWS::EC2::SecurityGroup --region $region --output text | grep $sgId

# Buscar todos os eventos realizados pelo usuário suspeito identificado
aws cloudtrail lookup-events --lookup-attributes AttributeKey=Username,AttributeValue=chaos --output text


# ---------------------------------------------------------
# Consultas SQL no Amazon Athena para cruzar os dados de forma mais rápida
# ---------------------------------------------------------

-- Consulta exploratória inicial
SELECT * FROM cloudtrail_logs_monitoring_rayssa_58291 LIMIT 5;

-- Consulta filtrando as colunas mais relevantes
SELECT useridentity.userName, eventtime, eventsource, eventname, requestparameters
FROM cloudtrail_logs_monitoring_rayssa_58291
LIMIT 30;

-- Consulta focada em eventos do EC2
SELECT useridentity.userName, eventtime, eventsource, eventname, requestparameters
FROM cloudtrail_logs_monitoring_rayssa_58291
WHERE eventsource = 'ec2.amazonaws.com';

-- Consulta filtrando eventos relacionados a segurança
SELECT useridentity.userName, eventtime, eventsource, eventname, requestparameters
FROM cloudtrail_logs_monitoring_rayssa_58291
WHERE eventsource = 'ec2.amazonaws.com' AND eventname LIKE '%Security%';

-- Consulta final - identifica quem abriu a porta 22 para o mundo
SELECT useridentity.userName, eventtime, eventsource, eventname, requestparameters
FROM cloudtrail_logs_monitoring_rayssa_58291
WHERE eventname = 'AuthorizeSecurityGroupIngress';

-- Consulta de apoio - toda atividade das últimas 24h por usuário
SELECT DISTINCT useridentity.userName, eventName, eventSource
FROM cloudtrail_logs_monitoring_rayssa_58291
WHERE from_iso8601_timestamp(eventtime) > date_add('day', -1, now())
ORDER BY eventSource;


# ---------------------------------------------------------
# Remover o acesso do invasor e corrigir o sistema operacional
# ---------------------------------------------------------

# Ver histórico de logins no sistema operacional
sudo aureport --auth

# Ver quem está conectado no momento
who

# Tentar remover o usuário indevido do SO (pode falhar se ele ainda estiver logado)
sudo userdel -r chaos-user

# Encerrar a sessão ativa do usuário (usar o PID retornado pelo comando anterior)
sudo kill -9 <ProcNum>

# Confirmar que o usuário foi desconectado
who

# Remover o usuário do SO (agora deve funcionar)
sudo userdel -r chaos-user

# Verificar se restam outros usuários suspeitos com login habilitado
sudo cat /etc/passwd | grep -v nologin


# ---------------------------------------------------------
# Corrigir a configuração SSH que havia sido comprometida
# ---------------------------------------------------------

# Ver data de modificação do arquivo de configuração SSH
sudo ls -l /etc/ssh/sshd_config

# Editar o arquivo (dentro do vi: comentar "PasswordAuthentication yes"
# e descomentar "PasswordAuthentication no")
sudo vi /etc/ssh/sshd_config

# Reiniciar o serviço SSH para aplicar as mudanças
sudo service sshd restart


# ---------------------------------------------------------
# Restaurar o site ao estado original
# ---------------------------------------------------------

cd /var/www/html/cafe/images/
ls -l

# Restaurar a imagem original a partir do backup deixado pelo próprio invasor
sudo mv Coffee-and-Pastries.backup Coffee-and-Pastries.jpg


# ---------------------------------------------------------
# Remover o acesso do usuário malicioso na conta AWS
# ---------------------------------------------------------
# Executado via Console da AWS: IAM > Usuários > selecionar "chaos" > Excluir
