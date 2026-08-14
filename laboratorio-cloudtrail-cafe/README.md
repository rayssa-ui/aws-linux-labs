# Investigação de Segurança AWS — Ataque ao Site do Café

## Visão Geral

Laboratório prático de resposta a incidentes na AWS, utilizando **CloudTrail**, **Athena**, **EC2** e **AWS CLI** para investigar uma invasão ao site institucional de um café, identificar o responsável e corrigir as falhas de segurança exploradas.

**Ambiente:**
- Instância EC2: `Cafe Web Server` (Amazon Linux 2)
- IP público: `34.219.79.222`
- Security Group: `sg-0b9af92bcffcaa49c` (WebSecurityGroup)

---

## O que foi feito

O laboratório começou com o site do Café funcionando normalmente, protegido apenas por uma regra de firewall liberando a porta 80 (HTTP) para o público. Adicionei uma segunda regra restringindo o acesso SSH (porta 22) apenas ao meu próprio IP, e confirmei que o site carregava normalmente.

Em seguida, criei uma trilha do **AWS CloudTrail** (`monitor`), configurada para armazenar os logs de auditoria em um bucket S3 (`monitoring-rayssa-58291`) com criptografia SSE-KMS. Pouco depois de a trilha entrar em funcionamento, o site foi invadido: uma das imagens da página foi substituída por uma ilustração de um macaco com óculos (desfiguração clássica de site, feita só "de brincadeira"). Ao inspecionar o grupo de segurança da instância, encontrei uma **regra nova e não autorizada**, liberando a porta 22 (SSH) para `0.0.0.0/0` — ou seja, qualquer IP do mundo.

Com o CloudTrail já habilitado, parti para a investigação. Conectei via SSH (PuTTY) à instância do servidor e baixei os arquivos de log do bucket S3, extraindo-os localmente. Usando `grep`, filtrei os logs em busca do evento `AuthorizeSecurityGroupIngress` (que é o nome da ação de abrir uma porta em um grupo de segurança) e encontrei a entrada responsável pela falha: o usuário **`chaos`**, agindo a partir do IP `34.219.79.222` (a própria instância do servidor). Complementei a investigação com comandos da **AWS CLI** (`aws cloudtrail lookup-events`), que confirmaram que a ação foi executada via linha de comando (AWS CLI), não pelo console web, e que o usuário `chaos` também operou a partir de uma segunda instância (`HackerInstance`, IP `35.87.14.19`).

Para consolidar a investigação de forma mais eficiente, também criei uma tabela no **Amazon Athena** a partir dos logs do CloudTrail e rodei consultas SQL para cruzar `userName`, `eventName`, `eventTime` e `sourceIPAddress`, confirmando a mesma conclusão de forma mais rápida e legível do que vasculhar arquivo por arquivo com `grep`.

Identificado o responsável, parti para a remediação. No sistema operacional da instância, encontrei um usuário indevido (`chaos-user`) ainda com sessão ativa, encerrei o processo dele e removi a conta. Descobri também que o arquivo de configuração do SSH (`/etc/ssh/sshd_config`) havia sido alterado no mesmo dia para permitir autenticação por senha — uma falha grave, já que normalmente só o par de chaves deveria dar acesso. Corrigi essa configuração, reiniciei o serviço SSH e removi a regra de firewall maliciosa que liberava a porta 22 para o mundo. Por fim, restaurei a imagem original do site (o próprio invasor havia deixado um backup do arquivo original) e removi o usuário `chaos` do AWS IAM, encerrando de vez o acesso dele à conta.

---

## 🕵️ Identificação do Hacker

| Item                          | Valor                                      |
|--------------------------------|---------------------------------------------|
| **Usuário AWS responsável**    | `chaos`                                     |
| **Ação maliciosa**              | `AuthorizeSecurityGroupIngress` (porta 22, origem 0.0.0.0/0) |
| **Endereço IP de origem**       | `34.219.79.222` (própria instância Café Web Server) e `35.87.14.19` (instância HackerInstance) |
| **Método de ataque**            | Linha de comando (AWS CLI), não via Console |

---

## Conclusão

O incidente foi originado por um usuário IAM comprometido (`chaos`), que ganhou acesso à instância EC2, alterou a configuração SSH para permitir autenticação por senha, abriu uma regra de firewall liberando SSH para toda a internet e desfigurou o site do Café.

A resposta ao incidente incluiu: identificação da causa raiz via CloudTrail e Athena, remoção do acesso do usuário malicioso (tanto no sistema operacional quanto no IAM), reversão das configurações de segurança comprometidas e restauração do conteúdo original do site.

**Principais aprendizados:**
- Importância de habilitar auditoria (CloudTrail) *antes* de incidentes ocorrerem.
- Uso de SQL (Athena) para investigação de logs em larga escala, muito mais eficiente que `grep` manual.
- Boas práticas reforçadas: acesso SSH restrito por IP, desabilitar autenticação por senha, princípio do menor privilégio para usuários IAM.

Os comandos utilizados em cada etapa estão detalhados em [`commands.sh`](./commands.sh).
