# AWS Systems Manager — Fleet Manager, Run Command, Parameter Store e Session Manager

Este laboratório explora quatro recursos do **AWS Systems Manager** para gerenciar instâncias EC2 sem a necessidade de acesso SSH direto: Fleet Manager (inventário), Run Command (execução remota), Parameter Store (configuração) e Session Manager (acesso via shell no navegador).

## Objetivo

Demonstrar como gerenciar, configurar e acessar instâncias EC2 de forma segura e auditável, sem abrir portas SSH, manter bastion hosts ou gerenciar chaves.

---

## 1. Fleet Manager — Inventário de instâncias gerenciadas

Usado para coletar informações do sistema operacional, aplicativos instalados e metadados de instâncias EC2.

**Passos realizados:**
- Acessado o **Fleet Manager** dentro do Systems Manager.
- Criada uma associação de inventário (`Inventory-Association`) direcionada manualmente à instância gerenciada.
- Validado o inventário coletado na aba **Inventory** da instância, listando os aplicativos instalados.

**Resultado:** o Systems Manager passou a realizar coletas regulares de inventário da instância, permitindo auditoria de software sem necessidade de conexão remota manual.

---

## 2. Run Command — Instalação de aplicativo personalizado

Usado para instalar um aplicativo web (**Widget Manufacturing Dashboard**)
