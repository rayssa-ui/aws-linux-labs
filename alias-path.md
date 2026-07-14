Alias e Variável PATH 🔧

## Descrição
Criação de alias para comandos e configuração da variável PATH.

## Alias
```bash
alias backup='tar -cvzf '              # cria alias chamado backup
backup backup_CompanyA.tar.gz CompanyA # usa o alias
```

## Variável PATH
```bash
echo $PATH                             # exibe o PATH atual
PATH=$PATH:/home/ec2-user/CompanyA/bin # adiciona pasta ao PATH
```

## Executando scripts
```bash
./hello.sh                             # executa na pasta atual
./bin/hello.sh                         # executa com caminho relativo
hello.sh                               # executa após adicionar ao PATH
```

## Observações
- Sem o PATH configurado, só é possível executar scripts com `./` na frente
- Após adicionar ao PATH, o script pode ser chamado pelo nome direto
