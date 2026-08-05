# VPC com Sub-redes Pública/Privada, NAT Gateway e Servidor Bastion

Laboratório de criação de uma Amazon VPC do zero, com sub-rede pública e privada, gateway de internet, gateway NAT e um servidor bastion (jump box) para acesso seguro a recursos privados.

## Arquitetura

- **VPC** (`10.0.0.0/16`) com nomes de host DNS ativados.
- **Sub-rede pública** (`10.0.0.0/24`), com atribuição automática de IP público.
- **Sub-rede privada** (`10.0.2.0/23`), sem acesso direto à internet.
- **Internet Gateway** anexado à VPC, roteado pela tabela de rotas pública.
- **Gateway NAT** na sub-rede pública, roteado pela tabela de rotas privada, permitindo que recursos na sub-rede privada iniciem conexões de saída para a internet sem serem acessíveis diretamente de fora.
- **Servidor Bastion** (EC2, Amazon Linux 2023, t3.micro) na sub-rede pública, atuando como ponto de acesso seguro para recursos na sub-rede privada.

## O que foi feito

1. Criação da VPC `Lab VPC` (CIDR `10.0.0.0/16`), com nomes de host DNS habilitados.
2. Criação da sub-rede pública (`10.0.0.0/24`) e da sub-rede privada (`10.0.2.0/23`), na mesma Zona de Disponibilidade.
3. Ativação de atribuição automática de IP público na sub-rede pública.
4. Criação e anexação de um Internet Gateway (`Lab IGW`) à VPC.
5. Configuração de duas tabelas de rotas:
   - **Public Route Table**: rota `0.0.0.0/0` → Internet Gateway, associada à sub-rede pública.
   - **Private Route Table** (renomeada a partir da tabela principal padrão): rota `0.0.0.0/0` → Gateway NAT, mantendo a rota local `10.0.0.0/16`.
6. Lançamento do servidor bastion (`Bastion Server`) na sub-rede pública, sem par de chaves (acesso via EC2 Instance Connect), com security group liberando SSH de qualquer origem.
7. Criação do Gateway NAT (`Lab NAT gateway`) na sub-rede pública, com IP elástico alocado automaticamente.

## Observações técnicas

- O modo "Regional" (mais recente) de criação do Gateway NAT retornou erro de permissão (`not authorized to create service-linked role for regional NAT Gateways`) na conta do laboratório. Foi utilizado o modo **Zonal**, que funcionou normalmente e é o modo compatível com o escopo original do laboratório.
- Ao adicionar rotas para o Gateway NAT ou Internet Gateway na tabela de rotas, é necessário selecionar o recurso a partir da lista suspensa (não apenas digitar o prefixo do ID), caso contrário a validação falha com "a valid resource id has to be specified".

## Resultado

Toda a infraestrutura de rede foi criada e validada com sucesso: VPC, sub-redes, gateways e tabelas de rotas configurados corretamente, com o servidor bastion em execução na sub-rede pública, pronto para servir como ponto de acesso a recursos futuros na sub-rede privada.

## Desafio opcional: teste da sub-rede privada

O desafio opcional foi concluído com sucesso, validando toda a infraestrutura de rede criada.

**O que foi feito:**

1. Lançamento de uma instância EC2 (`Private Instance`, Amazon Linux 2023, t3.micro) na sub-rede privada, com um novo security group (`Private Instance SG`) liberando SSH apenas a partir do bloco CIDR da VPC (`10.0.0.0/16`) — ou seja, apenas de recursos dentro da própria VPC, como o bastion.
2. Uso de um script de user data para habilitar autenticação por senha na instância privada (necessário já que essa instância não é acessível diretamente para configuração de chave SSH via EC2 Instance Connect).
3. Acesso ao **servidor bastion** na sub-rede pública via EC2 Instance Connect.
4. A partir do bastion, conexão via `ssh` até o endereço IP privado da instância na sub-rede privada, autenticando com a senha configurada pelo script de user data.
5. Teste de conectividade de saída com `ping -c 3 amazon.com`, executado a partir da instância privada.

**Resultado:** o `ping` teve sucesso, confirmando que a instância na sub-rede privada — sem IP público e sem acesso direto da internet — consegue se comunicar com a internet através do Gateway NAT. Isso validou de ponta a ponta toda a configuração de rede: VPC, sub-redes, tabelas de rotas, Internet Gateway e Gateway NAT funcionando corretamente em conjunto.
