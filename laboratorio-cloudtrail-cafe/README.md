# Investigação de Segurança AWS — Ataque ao Site do Café

## Visão Geral

Laboratório prático de resposta a incidentes na AWS, utilizando **AWS CloudTrail**, **Amazon Athena**, **EC2** e **AWS CLI** para investigar uma invasão ao site institucional de um café, identificar o responsável e corrigir as falhas de segurança exploradas.

**Ambiente:**
- Instância EC2: `Cafe Web Server` (Amazon Linux 2)
- IP público: `34.219.79.222`
- Security Group: `sg-0b9af92bcffcaa49c` (WebSecurityGroup)

---

## Tarefa 1 — Configuração inicial e observação do site

- Acesso ao grupo de segurança da instância `Cafe Web Server`.
- Regra de entrada original: apenas **HTTP (porta 80)** liberado para `0.0.0.0/0`.
- Adicionada nova regra de entrada:
  - **Tipo:** SSH
  - **Porta:** 22
  - **Origem:** My IP (`200.171.204.186/32`)
- Site acessado em `http://34.219.79.222/cafe/` — funcionando normalmente.

---

## Tarefa 2 — Criação da trilha CloudTrail e detecção da invasão

### 2.1 Criação da trilha
- **Nome da trilha:** `monitor`
- **Bucket S3 criado:** `monitoring-rayssa-58291`
- **Alias KMS:** `ra-KMS`
- Criptografia SSE-KMS habilitada.
- ⚠️ Obs.: primeira tentativa de nome de bucket (`monitoring1234`) falhou por já estar em uso globalmente — nomes de bucket S3 são únicos em toda a AWS.

### 2.2 Site invadido
- Após recarregar o site (`Shift + refresh`), a imagem dos croissants foi substituída por uma imagem de um macaco com óculos "Be Cool" — evidência clara de desfiguração (*defacement*).
- Verificação do grupo de segurança revelou **regra extra não autorizada**:

| Porta | Protocolo | Origem      | Observação                  |
|-------|-----------|-------------|------------------------------|
| 80    | TCP       | 0.0.0.0/0   | Normal (HTTP público)        |
| 22    | TCP       | 200.171.204.186/32 | Criada por nós (SSH restrito) |
| 22    | TCP       | **0.0.0.0/0** | 🚨 **Criada pelo invasor** — SSH liberado ao mundo |

---

## Tarefa 3 — Análise dos logs via SSH, grep e AWS CLI

### 3.1–3.3 Conexão e download dos logs
- Conexão via **PuTTY** (Windows) com chave `labsuser.ppk`, usuário `ec2-user`.
- Logs baixados do bucket S3 para a instância:
```bash
  mkdir ctraillogs && cd ctraillogs
  aws s3 ls
  aws s3 cp s3://monitoring-rayssa-58291/ . --recursive
```
- Arquivos `.json.gz` extraídos com `gunzip *.gz`.

### 3.4 Análise com grep
Busca direta pelo evento de abertura de porta no grupo de segurança:
```bash
grep -l "AuthorizeSecurityGroupIngress" *.json
```

**Resultado — evidência do ataque encontrada:**
```json
"eventName": "AuthorizeSecurityGroupIngress",
"sourceIPAddress": "34.219.79.222",
"userName": "chaos"
```

### 3.5 Confirmação via AWS CLI
```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=Username,AttributeValue=chaos --output text
```
- Confirmado uso de **AWS CLI** (`userAgent: aws-cli/1.18.147 Python/2.7.18...`) a partir da instância `HackerInstance` (IP `35.87.14.19`), não pelo Console Web.

---

## Tarefa 4 — Análise com Amazon Athena

- Tabela Athena criada automaticamente a partir
