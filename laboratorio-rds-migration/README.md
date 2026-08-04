# Migrando para o Amazon RDS

Laboratório de migração de um banco de dados MariaDB local (rodando em uma instância EC2, como parte de uma stack LAMP) para uma instância totalmente gerenciada do Amazon RDS.

## O que foi feito

1. Geração de dados de teste: pedidos criados no site do café, armazenados no banco de dados local.
2. Configuração da AWS CLI com credenciais temporárias (access key, secret key e session token) no host da CLI.
3. Criação dos componentes de rede necessários para o RDS:
   - Security group `CafeDatabaseSG`, com regra de entrada liberando a porta 3306 (MySQL) apenas para instâncias associadas ao security group da aplicação.
   - Duas sub-redes privadas em Zonas de Disponibilidade diferentes (`us-west-2a` e `us-west-2b`).
   - Um grupo de sub-redes de banco de dados (`CafeDB Subnet Group`) combinando as duas sub-redes.
4. Criação da instância Amazon RDS MariaDB (`CafeDBInstance`), classe `db.t3.micro`, 20 GB de armazenamento, sem acesso público.
5. Migração dos dados:
   - Backup do banco local com `mysqldump`.
   - Download do certificado SSL/TLS da AWS (obrigatório para conexões com RDS).
   - Restauração do backup no banco RDS via `mysql` com conexão criptografada.
   - Validação dos dados migrados (consulta `SELECT * FROM product`, todos os 9 produtos do menu confirmados).
6. Reconfiguração do aplicativo via AWS Systems Manager Parameter Store, atualizando o parâmetro `/cafe/dbUrl` para apontar ao endpoint do RDS.
7. Monitoramento da instância RDS através de métricas do Amazon CloudWatch (CPU, conexões, armazenamento, memória, IOPS).

## Ajuste de versão

A versão do MariaDB especificada no laboratório original (`10.11.11`) não estava mais disponível na região. Foi utilizada a versão mais recente disponível na mesma série: `10.11.18`.

## Resultado

Os dados foram migrados com sucesso e validados diretamente no banco RDS. A reconfiguração do parâmetro no Systems Manager apresentou um erro de autenticação a ser investigado (o site retornou "Access denied", sugerindo um valor incorreto colado no parâmetro `/cafe/dbUrl`) — próximo passo de troubleshooting para uma futura sessão.

## Arquitetura

- **Antes**: aplicação e banco de dados na mesma instância EC2 (stack LAMP), em sub-rede pública.
- **Depois**: aplicação continua na instância EC2 (sub-rede pública), banco de dados migrado para uma instância Amazon RDS MariaDB em sub-redes privadas dedicadas, na mesma VPC.
