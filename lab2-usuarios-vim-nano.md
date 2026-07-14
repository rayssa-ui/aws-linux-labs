# Lab 2 — Usuários, Vim e Nano 👥

## Descrição
Gerenciamento de usuários Linux e edição de arquivos com Vim e Nano.

## Comandos de Usuários
```bash
sudo useradd arosalez                    # cria usuário
sudo passwd arosalez                     # define senha
sudo cat /etc/passwd | cut -d : -f1     # lista usuários
sudo lastlog                             # último login de cada usuário
```

## Vim
```bash
vimtutor          # tutorial interativo do Vim
vim helloworld    # cria/abre arquivo
```

### Atalhos Vim
| Comando | Ação |
|---------|------|
| `i` | modo inserção |
| `ESC` | sair do modo inserção |
| `:wq` | salvar e sair |
| `:q!` | sair sem salvar |
| `dd` | deletar linha |
| `u` | desfazer |

## Nano
```bash
nano cloudworld   # cria/abre arquivo
```

### Atalhos Nano
| Comando | Ação |
|---------|------|
| `CTRL+O` | salvar |
| `CTRL+X` | sair |
