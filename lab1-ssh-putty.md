# Lab 1 — Conexão SSH com PuTTY 🔐

## Descrição
Conexão em uma instância EC2 da AWS usando PuTTY via SSH.

## Configuração do PuTTY

### 1. Credenciais
- Baixar `labsuser.ppk` no painel **Detalhes → Mostrar**
- Anotar o **IP público** da instância

### 2. Configuração
- **Host Name:** `ec2-user@IP_PUBLICO`
- **Porta:** `22`
- **Tipo:** `SSH`
- **Chave:** Connection → SSH → Auth → Credentials → `labsuser.ppk`

## Comandos
```bash
pwd                  # mostra a pasta atual
ls                   # lista arquivos
cd /home/ec2-user    # navega para a pasta
```

## Observações
- O IP muda toda vez que o lab é reiniciado
- No PuTTY, colar texto é feito com botão direito do mouse
