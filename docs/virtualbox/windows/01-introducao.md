# Introdução ao Laboratório com Oracle VirtualBox

O Oracle VirtualBox é um programa de virtualização que permite rodar sistemas operacionais inteiros dentro do nosso computador de forma isolada e sem precisar formatar ou alterar a máquina principal.

Em vez de instalar o Linux direto no HD físico, criamos uma máquina virtual (VM). O VirtualBox reserva uma fatia dos nossos recursos reais como o processador, a memória RAM, discos e placa de redes, entregando para essa VM (máquina virtual) funcionar como se fosse um outro computador físico dentro do sistema operacional.

Isso permite um ambiente seguro e controlado para estudar, testar configurações, subir serviços de infraestrutura e praticar comandos sem qualquer risco para o sistema operacional do dia a dia.

Neste projeto, utilizaremos o VirtualBox em um computador com Windows 10 para criar e configurar um laboratório baseado no GNU/Linux Ubuntu.

---

## Objetivo do Projeto

O objetivo deste projeto é registrar e guiar, de forma prática o passo a passo, a montagem e o uso de uma máquina virtual focada no estudo de Linux, redes, contêineres com Docker, automação e práticas de DevOps.

Durante a construção e uso do laboratório, cobriremos os seguintes tópicos:

* Instalação e preparação do Oracle VirtualBox
* Criação da máquina virtual do zero
* Definição e ajuste de memória RAM e núcleos de CPU
* Configuração do disco rígido virtual e armazenamento
* Ajustes das interfaces de rede
* Instalação limpa do sistema operacional Ubuntu
* Instalação e ativação das Guest Additions (Adicionais de Convidado)
* Mapeamento de pastas compartilhadas entre o Windows e o Linux
* Criação e restauração de snapshots (pontos de checagem)
* Comandos e rotinas básicas para administração da máquina

Começaremos com uma estrutura simples e bem alinhada, onde futuramente usaremos essa mesma máquina como base para laboratórios mais avançados.

---

## O que é Virtualização?

Virtualização é a tecnologia que nos permite utilizar os recursos físicos de um computador real para criar e rodar múltiplos ambientes computacionais virtuais ao mesmo tempo.

Assim, uma única máquina física consegue manter vários sistemas operacionais rodando de maneira independente.

Veja como fica a estrutura visual do nosso ambiente:

```text
Computador Físico
        |
        v
+-----------------------+
|  Sistema Windows      |
|                       |
|  Oracle VirtualBox    |
+-----------------------+
        |
        +-----------------------+
        |                       |
        v                       v
+---------------+       +---------------+
| ubuntu-lab    |       | outra-vm      |
| Ubuntu Linux  |       | Linux         |
+---------------+       +---------------+
```


Cada máquina virtual opera em seu próprio espaço reservado, executando o seu sistema sem interferir nas outras máquinas virtuais.

---

## Diferença entre Máquina Física e Máquina Virtual

Para entender o funcionamento do VirtualBox sem confusão, vale alinhar três conceitos fundamentais:

### Host (Hospedeiro)
É o computador físico onde o VirtualBox está instalado.

Neste laboratório:
Host: Windows 10

O Host é quem empresta a infraestrutura e os componentes reais:
* Processador (CPU)
* Memória RAM (física)
* Armazenamento (SSD / HD)
* Placa de rede e Wi-Fi
* Entradas USB e demais periféricos

### Guest (Convidado)
É o sistema operacional que roda "preso" dentro da máquina virtual.

Neste laboratório:
Guest: Ubuntu

O Ubuntu não acessa diretamente o hardware físico; ele interage apenas com os componentes virtuais disponibilizados pelo VirtualBox.

### Máquina Virtual (VM)
É a estrutura virtual criada pelo VirtualBox para acomodar e rodar o sistema Guest.

Neste projeto:
Máquina Virtual: ubuntu-lab

A VM enxerga e utiliza recursos simulados:
vCPU (Processador Virtual)
vRAM (Memória RAM Virtual)
Disco Virtual (.vdi / .vmdk)
Placa de Rede Virtual
Controladoras Virtuais

Esses elementos funcionam para o sistema virtualizado exatamente como funcionariam os componentes de um computador real.

---

## Estrutura do Nosso Laboratório

O ambiente deste projeto será organizado no seguinte fluxo:

```text
Windows
   |
   v
Oracle VirtualBox
   |
   v
Máquina Virtual (ubuntu-lab)
   |
   v
Ubuntu
   |
   +-- Rede (NAT)
   |
   +-- Guest Additions (Adicionais para Convidado)
   |
   +-- Pasta Compartilhada
   |
   +-- Snapshots / Rollback (Reversão)
```

Usaremos este formato como base para todas as nossas práticas e testes futuros.

---

## Vantagens de Usar uma Máquina Virtual

Para quem está estudando, a máquina virtual é excelente porque garante liberdade para testar e errar sem medo de danificar o sistema operacional principal do computador.

Podemos usar a VM para praticar, por exemplo:

* Instalação e administração de servidores Linux
* Testes de rotas, firewalls e redes
* Configuração de serviços de sistema
* Treinar comandos no terminal e Shell Script
* Execução e gerenciamento de contêineres com Docker
* Subir servidores web (Nginx / Apache)
* Configuração de ambientes de programação e bancos de dados (PHP, MariaDB, Redis)
* Simulação de cenários reais de infraestrutura e pipelines de DevOps

Se qualquer comando ou alteração quebrar o sistema, basta usar um snapshot para retornar a máquina ao estado correto em poucos segundos.

---

## O VirtualBox no Nosso Ambiente de Testes

O Oracle VirtualBox é uma das melhores escolhas para estudos porque permite subir e gerenciar várias máquinas de forma intuitiva a partir do sistema operacional que já utilizamos diariamente.

Exemplo de uso no dia a dia:

```text
Windows
   |
   +-- VirtualBox
          |
          +-- Ubuntu Server (ubuntu-lab)
          |
          +-- Debian (futuro)
          |
          +-- Windows Server (futuro)
          |
          +-- Outras VMs
```

A quantidade de VMs que você consegue rodar ao mesmo tempo vai depender exclusivamente do hardware físico (RAM, CPU e disco) que o seu computador tem disponível.



---

## O Papel do Hypervisor

O software encarregado de criar, emular e gerenciar os ambientes virtuais é chamado de Hypervisor.

O Oracle VirtualBox se enquadra como um Hypervisor do Tipo 2 (Hospedado). Isso significa que ele precisa de um sistema operacional tradicional instalado no hardware físico para funcionar.

A pilha de camadas fica organizada desta maneira:

```text
Hardware Físico
       |
       v
Sistema Operacional Host (Windows)
       |
       v
Oracle VirtualBox (Hypervisor Tipo 2)
       |
       v
Sistema Operacional Guest (Ubuntu)

Neste laboratório, a estrutura prática será:

Hardware
   |
   v
Windows
   |
   v
Oracle VirtualBox
   |
   v
Ubuntu
```

Esse modelo é diferente dos Hypervisors Tipo 1 (bare-metal), que são instalados diretamente no hardware sem precisar de um sistema como o Windows por baixo.

---

## Configuração dos Recursos Virtuais

A nossa máquina virtual terá seus recursos mapeados para entregar boa performance de testes sem pesar no computador principal.

### CPU
Definimos a quantidade de núcleos virtuais de processamento para a VM.

Neste laboratório:
CPU: 2 vCPUs

### Memória RAM
A quantidade de memória alocada para a execução da VM.

Neste laboratório:
RAM: 2048 MB (2 GB)

### Armazenamento
A VM usará um arquivo de disco rígido virtual para salvar o sistema e os dados.

Neste laboratório:
Disco: 20 GB (Alocação dinâmica)

Esse disco será utilizado para a instalação do sistema operacional Ubuntu.

### Rede
O VirtualBox oferece modos de rede virtuais para conectar a VM (máquina virtual) à internet, ao Host ou a outras VMs.

Inicialmente usaremos:
Modo de Rede: NAT

Os detalhes de configuração de rede serão demonstrados nos passos práticos para o Windows.

---

## Especificações da Máquina no Laboratório

A tabela abaixo resume a configuração inicial combinada para a nossa máquina virtual:

| Recurso | Configuração Adotada |
| :--- | :--- |
| **Nome da VM** | `ubuntu-lab` |
| **Sistema Operacional** | Ubuntu Linux |
| **Processador** | 2 vCPUs |
| **Memória RAM** | 2048 MB |
| **Disco Virtual** | 20 GB |
| **Rede** | Modo NAT |
| **Sistema Host** | Windows |
| **Hypervisor** | Oracle VirtualBox |

Essa alocação é ideal para iniciar o laboratório e pode ser ajustada conforme a necessidade dos próximos projetos.

---

## Recursos Adicionais do VirtualBox

### Guest Additions (Adicionais para Convidado)
O VirtualBox conta com um pacote de utilitários chamado Guest Additions, que é instalado dentro do sistema Guest (Ubuntu) para melhorar a integração com o Host (Windows).

Dentre as melhorias, destacam-se:
* Captura e liberação fluida do ponteiro do mouse
* Ajuste automático da resolução da janela
* Recorte e cola compartilhado (clipboard)
* Suporte a pastas compartilhadas nativas
* Aceleração gráfica básica

Usaremos o Guest Additions principalmente para integrar diretórios entre o Windows e o Ubuntu.

### Pastas Compartilhadas
A pasta compartilhada permite mapear um diretório do Windows para ser acessado direto pelo terminal do Linux.

Fluxo do mapeamento:

```text
Windows: C:\VirtualBox\Shared
             |
             v
Oracle VirtualBox
             |
             v
Ubuntu: /mnt/shared
```

Isso facilita a troca de arquivos, scripts e códigos entre o Windows e a VM durante as aulas.

A configuração desse passo está documentada em:
`docs/windows/06-pastas-compartilhadas.md`

### Snapshots (Pontos de Restauração) 
O snapshot funciona como um registro do estado exato da VM em um determinado instante.

Exemplo de uso:

```text
Ubuntu Instalado
       |
       v
Configuração Inicial Pronta
       |
       v
Criar Snapshot 01
       |
       v
Execução de Testes / Instalações
       |
       v
Ocorreu um Erro -> Restaurar Snapshot 01
```

Se algum teste danificar o ambiente, basta restaurar o snapshot e a VM volta instantaneamente para o ponto em que a imagem foi tirada.

Nota: Snapshots servem para testes e laboratórios, mas não substituem rotinas de backup definitivo.

---

## Usando a VM para Estudos de DevOps

Com o ambiente Ubuntu pronto e funcional, nossa VM vai servir de base para aprender e exercitar diversas tecnologias de infraestrutura:

```text
Linux
   |
   +-- Shell / Terminal
   +-- Conexão SSH
   +-- Redes e Firewalls
   +-- Servidores Nginx e Apache
   +-- Linguagens e Ambientes (PHP, Python)
   +-- Bancos de Dados (MariaDB, Redis)
   +-- Contêineres com Docker
   +-- Controle de Versão com Git
   +-- Automação de Tarefas
   +-- Conceitos de CI/CD e DevOps
```

Isso nos permite explorar um ecossistema completo usando apenas um computador pessoal.

---

## Criando Ambientes Isolados para Teste

A maior vantagem da virtualização no aprendizado é o isolamento completo do ambiente.

Podemos executar qualquer alteração no Ubuntu com a certeza de que o Windows permanecerá 100% protegido.

```text
Windows
   |
   +-- Oracle VirtualBox
          |
          +-- Ubuntu (ubuntu-lab)
                 |
                 +-- Testes de Comandos
                 +-- Alterações de Rede
                 +-- Subida de Serviços
                 +-- Experimentos com Contêineres
```

Esse formato dá tranquilidade para explorar configurações complexas e refazer o ambiente quantas vezes forem necessárias.

---

## O que Será Construído neste Projeto

Ao longo dos guias, montaremos uma VM Ubuntu totalmente pronta e ajustada para o uso diário.

O roteiro do projeto segue esta ordem:

```text
01 - Introdução ao Projeto
        |
        v
02 - Conceitos de Virtualização
        |
        v
Windows (Passos Práticos)
        |
        +-- 01. Instalação do VirtualBox
        |
        +-- 02. Criação da Máquina Virtual
        |
        +-- 03. Configuração dos Recursos
        |
        +-- 04. Instalação do Ubuntu
        |
        +-- 05. Ajuste de Rede
        |
        +-- 06. Pastas Compartilhadas
        |
        +-- 07. Snapshots
```

Ao final dessa sequência, teremos um laboratório limpo e funcional para os próximos conteúdos.

---

## Organização dos Arquivos de Documentação

A estrutura de arquivos do nosso repositório está dividida entre conceitos gerais e os passos práticos por sistema operacional:

```text
docs/
├── 01-introducao.md
├── 02-virtualizacao.md
└── windows/
    ├── 01-instalando-o-virtualbox.md
    ├── 02-criando-a-maquina-virtual.md
    ├── 03-configurando-a-maquina-virtual.md
    ├── 04-instalando-o-ubuntu.md
    ├── 05-configurando-a-rede.md
    ├── 06-pastas-compartilhadas.md
    └── 07-snapshots.md
```

Futuramente, os tutoriais focados no Host em Linux serão adicionados mantendo esse mesmo padrão de pastas.

---

## Considerações Finais

O objetivo deste guia não é apenas ensinar a instalar um programa, mas sim ajudar a montar uma infraestrutura sólida de estudos que você possa reaproveitar em diversos cursos e projetos.

A partir desta VM Ubuntu, será possível simular servidores reais, testar automações e criar documentações de forma organizada.

---

## Próximos Passos

Antes de abrir o instalador do VirtualBox, acesse o documento que detalha a parte teórica da virtualização.

Próximo documento:
`docs/windows/02-virtualizacao.md`

