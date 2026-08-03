# Solução de Problemas na Criação de uma Instância EC2 (Stack LAMP)

Laboratório de troubleshooting: uso da AWS CLI para lançar uma instância EC2 configurada como stack LAMP (Linux, Apache, MariaDB, PHP), hospedando o aplicativo web "Café". O script fornecido continha bugs propositais que precisaram ser diagnosticados e corrigidos.

## O que foi feito

1. Conexão à instância de host da CLI via EC2 Instance Connect.
2. Configuração da AWS CLI com as credenciais do laboratório.
3. Backup e leitura de um script bash (`create-lamp-instance-v2.sh`) responsável por:
   - Buscar dinamicamente a VPC, subnet, key pair e AMI corretos.
   - Limpar recursos antigos (instância e security group) de execuções anteriores.
   - Criar um security group com as portas 22 e 80.
   - Lançar a instância EC2 com um arquivo de user data que instala Apache, PHP e MariaDB.

## Bugs encontrados e corrigidos

**Bug 1 — Região incorreta no comando `run-instances`**
O script buscava a VPC, subnet e AMI usando a variável `$region` (dinâmica), mas o comando final de criação da instância tinha a região fixada como `us-east-1`. Isso causava o erro `InvalidAMIID.NotFound`, já que a AMI só existia na região correta do laboratório.
Correção: substituição de `us-east-1` pela variável `$region`.

**Bug 2 — Porta errada no Security Group**
O comentário do script indicava a abertura da porta 80 (HTTP), mas o valor real usado no comando era `8080`. Isso deixava o servidor Apache (porta 80) inacessível externamente.
Correção: substituição de `8080` por `80`.

## Ferramentas de diagnóstico utilizadas

- Leitura de mensagens de erro da AWS CLI para localizar a causa raiz.
- `nmap -Pn <ip>` para verificar quais portas estavam realmente abertas na instância.
- `tail -f /var/log/cloud-init-output.log` para acompanhar a execução do script de user data e confirmar a instalação do Apache, PHP e MariaDB sem erros.

## Resultado

Após as correções, a instância foi criada com sucesso, o site do Café ficou acessível publicamente, e o fluxo completo de pedidos (criação e histórico) foi validado, confirmando a integração correta entre o servidor web e o banco de dados MariaDB.

## Arquivos

- `create-lamp-instance-v2.sh`: script corrigido, usado para criar a instância.
- `create-lamp-instance-userdata-v2.txt`: script de user data (fornecido pelo laboratório) que instala e configura a stack LAMP e implanta o aplicativo Café.
