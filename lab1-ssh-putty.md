# Lab 1 — Conexão SSH com PuTTY 🔐

## O que aprendi
Conectar em uma instância EC2 da AWS usando o PuTTY via SSH.

## Passos realizados

### 1. Baixar credenciais
- Acessei o painel do laboratório em **Detalhes → Mostrar**
- Baixei o arquivo `labsuser.ppk`
- Anotei o **IP público** da instância

### 2. Configurar o PuTTY
- Abri o PuTTY
- Em **Session → Host Name** coloquei: `ec2-user@IP_PUBLICO`
- Porta: `22` | Tipo: `SSH`
- Em **Connection → SSH → Auth → Credentials** carreguei o `labsuser.ppk`
- Salvei a sessão e cliquei em **Open**

### 3. Comandos usados
```bash
pwd                  # mostra a pasta atual
ls                   # lista arquivos
cd /home/ec2-user    # navega para a pasta
```

## Observações
- O IP muda toda vez que o lab é reiniciado
- A chave PPK é necessária para autenticação
- No PuTTY, colar texto é feito com botão direito do mouse
