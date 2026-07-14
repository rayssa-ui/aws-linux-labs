Processos e Cron Job ⚙️

## Descrição
Monitoramento de processos e agendamento de tarefas com cron.

## Processos
```bash
sudo ps -aux                            # lista todos os processos
sudo ps -aux | grep -v root             # filtra processos sem root
top                                     # monitor de processos em tempo real
top -hv                                 # versão e ajuda do top
```

### Campos do comando top
| Campo | Descrição |
|-------|-----------|
| Tasks | total de tarefas |
| running | tarefas em execução |
| sleeping | tarefas em repouso |
| stopped | tarefas paradas |
| zombie | tarefas zumbi |

## Cron Job
```bash
sudo crontab -e                         # edita o crontab
sudo crontab -l                         # lista tarefas agendadas
```

### Estrutura do crontab
SHELL=/bin/bash
PATH=/usr/bin:/bin:/usr/local/bin
MAILTO=root
0 * * * * comando                       # executa a cada hora

### Campos do cron
| Campo | Valor |
|-------|-------|
| minuto | 0-59 |
| hora | 0-23 |
| dia do mês | 1-31 |
| mês | 1-12 |
| dia da semana | 0-7 |
