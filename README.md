
# Atividade de Linux + AWS | COMPASS UOL


## Requisitos AWS

- Gerar uma chave pública para acesso ao ambiente;

- Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16GB SSD);

- Gerar 1 elastic IP e anexar à instância EC2;

- Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP);

## Requisitos Linux

- Configurar o NFS entregue;

- Criar um diretorio dentro do filesystem do NFS com seu nome;

- Subir um apache no servidor - o apache deve estar online e rodando;

- Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretorio no nfs;

- O script deve conter - DATA HORA + nome do serviço + STATUS + mensagem personalizada de ONLINE ou OFFLINE;

- O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;

- Preparar a execução automatizada do script a cada 5 minutos;

- Fazer a [documentação](https://github.com/jeancalistro/atv-linux-aws-compass/blob/main/documenta%C3%A7%C3%A3o%20instala%C3%A7%C3%A3o%20fedora.pdf) explicando o processo de instalação do Linux

## Gerar chave de acesso

### SSH-KEYGEN

```bash
ssh-keygen -b 2048 -t rsa
```

### Importando a chave pública (.pub)

- Na console AWS procure pela EC2 feature **Key Pairs**
- No painel de navegação, selecione **Ações > Importar par de chaves**

### Console AWS

- Procure pelo EC2 feature **Key Pairs**
- No painel de navegação, selecione **Criar par de chaves**
- Insira um nome para o par de chave e o formato do arquivo

## Criar instância EC2

### Console AWS

- Procure pelo serviço **EC2**
- No painel de navegação, selecione **Instâncias > Executar instâncias**
- Adicione as **Tags** necessárias
- Selecione a **AMI** Amazon Linux 2
- Escolha o tipo de instância **t3.small**
- Selecione o **par de chaves** gerado anteriormente
- Edite se necessário as configurações de rede
- Insire **16 GB** nas configurações de armazenamento **SSD**
- Selecione **Executar instância**

## Alocar e Associar o Elastic IP

### Console AWS

- Procure pelo EC2 feature **Elastic IPs**
- No painel de navegação, selecione **Alocar endereço IP elástico**
- Selecione o Elastic IP alocado
- Escolha a opção **Ações > Associar endereço IP elástico**

## Liberar portas para acesso público

### Console AWS

- Procure pelo EC2 feature **Security groups**
- Selecione o **Security Group** associado a instância
- Escolha a opção **Editar regras de entrada > Adicionar regra**
- Para cada uma das seguinte portas, **22/TCP, 111/TCP/UDP, 2049/TCP/UDP, 80/TCP, 443/TCP**, adicione uma nova regra

## Configurar NFS

### Instalar o pacote nfs-utils

```bash
sudo yum install nfs-utils
```

### Criar o diretório que vai ser compartilhado

```bash
mkdir shared-dir
```

### Criar um diretório com seu nome dentro do filesystem NFS

```bash
mkdir shared-dir/jean
```

### Conceder as permissões necessárias

```bash
sudo chmod 777 shared-dir
```

### Adicionar o diretório criado no arquivo /etc/exports

```bash
/shared-dir *(rw)
```

### Aplicar as novas configurações

```bash
sudo exportfs -a
```

### Iniciar os serviços NFS-SERVER e RPCBIND

```bash
sudo systemctl start nfs-server
sudo systemctl start rpcbind
```
## Serviço Apache

### Instalar o Apache

```bash
sudo yum install httpd
```

### Iniciar o serviço do Apache

```bash
sudo systemctl start httpd
```
## Script para verificação do serviço

### Modo de uso

```bash
./srvcheck -s <service> -o <output path> -t <timezone> -a <message if online> -i <message if offline>
```

```bash
./srvcheck -s httpd -o /shared-dir/jean -t America/Sao_Paulo -a "Serviço Online" -i "Serviço Offline"
```

- [srvcheck](https://github.com/jeancalistro/atv-linux-aws-compass/blob/main/srvcheck.sh)

## Execução automática do script a cada 5 minutos

### Agendamento com Cron

```bash
sudo crontab -e
```

### Adicionar o seguinte conteúdo

```bash
*/5 * * * * srvcheck.sh -s httpd -o /shared-dir/jean
```