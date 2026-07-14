Estrutura de Pastas e Backup 📁

## Descrição
Criação de estrutura de pastas e backup de arquivos na EC2.

## Estrutura criada
CompanyA/
├── Finance/
│   ├── Salary.csv
│   └── ProfitAndLossStatements.csv
├── HR/
│   ├── Assessments.csv
│   └── TrialPeriod.csv
└── Management/
├── Managers.csv
└── Schedule.csv

## Comandos
```bash
mkdir CompanyA                          # cria pasta
mkdir Finance HR Management             # cria subpastas
touch Salary.csv ProfitAndLossStatements.csv  # cria arquivos
ls -laR                                 # lista tudo recursivamente
mv Management HR                        # move pasta
cp -r Finance HR                        # copia pasta
rm arquivo.csv                          # remove arquivo
rmdir pasta                             # remove pasta vazia
```

## Backup
```bash
tar -csvpzf backup.CompanyA.tar.gz CompanyA   # cria backup
ls                                             # verifica arquivo criado
```
