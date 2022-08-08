#!/usr/bin/env bash
#
# iac3_dio.sh - Atomatizando a criação de infraetrutura.
#
# E-mail:     liralc@gmail.com
# Autor:      Anderson Lira
# Manutenção: Anderson Lira
#
# ************************************************************************** #
#  Utilização do Docker no Cenário de Microsserviços
#
#  Exemplos de execução:
#      $ ./iac3.sh
#
# ************************************************************************** #
# Histórico:
#
#   v1.0 29/07/2022, Anderson Lira:
#       - Início do programa.
#
# ************************************************************************** #
# Testado em:
#   bash 5.0.3
#   Ubuntu 20.1
# ************************************************************************** #
#
# ======== VARIAVEIS ============================================================== #
export DIA_LOG=$(date +%d%m%Y-%H%M%S)
FILE_LOG="/dados/Logs/iacl_$DIA_LOG.log"
DIR_LOCAL="/mnt/driver"
VERDE="\033[32;1m]"
VERMELHOP="\033[31;1;5m]"
# ================================================================================ #
# ======== TESTES ================================================================ #
if [ $(echo $UID) -ne 0 ]
then
    echo -e "${VERMELHOP}Você deve está com privilégios de ROOT para continuar com esse programa." | tee -a "$FILE_LOG"
    exit 1
fi

if [ ! $(ping www.google.com -c 3) > /dev/null ]
then
    echo -e "${VERDE}Para a instalação do VNC, a sua máquina precisa está conectada na internet. " | tee -a "$FILE_LOG"
    exit 1
fi

echo "Verificando a existência do diretório para os logs." | tee -a "$FILE_LOG"
if [ -d /dados/Logs ]; then
    echo "Diretório de logs existente." | tee -a "$FILE_LOG"
else
    echo "Criando diretório para logs..." | tee -a "$FILE_LOG"
    mkdir -p  /dados/Logs
fi
# =================================================================================== #
# ======== FUNCOES ================================================================== #
function updateSystem () {
    apt-get update ; apt-get upgrade -y ; apt-get dist-upgrade -y ; apt autoremove
}
# =================================================================================== #
# ======== EXECUCAO DO PROGRAMA ===================================================== #
cd /var/lib/docker/volumes/app/_data/index.php
docker run --name web-server -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdeveloper/php-apache:alpine-php7
docker swarm init
#docker node ls
docker service create --name web-server --replicas 10 -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7
#docker service ps web-service
apt-get install nfs-server
echo '/var/lib/docker/volumes/app/_data/ *(rw,sync,subtree-check)' >> /etc/exports
exportfs -ar
showmount -e
mkdir /proxy
cd proxy


# =================================================================================== #
