# Análise de Logs 📋

## Descrição
Análise de arquivos de log e monitoramento de logins no Linux.

## Comandos
```bash
sudo less /tmp/log/secure              # visualiza log de segurança
sudo lastlog                           # último login de cada usuário
q                                      # sai do visualizador
```

## Arquivo de log seguro
- Localização padrão: `/var/log/secure`
- Contém informações de autenticação e falhas de login
- Mostra IP de origem, porta utilizada e status da autenticação

## lastlog
- Lista todos os usuários do sistema
- Mostra data e hora do último login
- Usuários que nunca fizeram login aparecem como **Never logged in**
