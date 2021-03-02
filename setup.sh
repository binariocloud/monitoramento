#! /bin/sh
#Instalação dos pacotes necessários
apt update
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt update
apt install docker-ce -y
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#Identificação do IP principal do servidor de monitoramento
IP_SERVER=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
echo IP_SERVER=http://$IP_SERVER:9000/ > monitoramento/var.env
#Configuração de senhas dos bancos de dados
clear
MYSQL_PASSWORD=$(/lib/cryptsetup/askpass "Insira a senha do serviço de bancos de dados:")
echo MYSQL_PASSWORD=$MYSQL_PASSWORD >> monitoramento/var.env
#Password pepper aleatório para o Graylog
RANDOMPEPPER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo RANDOMPEPPER=$RANDOMPEPPER >> monitoramento/var.env
echo
echo
#Configuração se senha de acesso ao Graylog
GRAYLOG_PASSWORD_TEMP=$(/lib/cryptsetup/askpass "Insira a senha do Graylog:")
GRAYLOG_PASSWORD=$(echo $GRAYLOG_PASSWORD_TEMP | tr -d '\n' | sha256sum | cut -d" " -f1)
echo GRAYLOG_PASSWORD=$GRAYLOG_PASSWORD >> monitoramento/var.env
docker-compose --env-file monitoramento/var.env -f monitoramento/docker-compose.yml up -d
#IP_SERVER=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
echo > monitoramento/var.env
echo
clear
#Delay para término do setup
echo "Aguarde enquanto as implemetações são concluídas"
sleep 30s
clear
echo
echo
#Fim da instalação e configuração
echo 'INSTALAÇÃO CONCLUÍDA, PARA ACESSAR OS SISTEMAS UTILIZE AS SEGUINTES INFORMAÇÕES:'
echo
echo PARA ACESSAR O ZABBIX INSIRA O SEGUINTE ENDEREÇO EM SEU NAVEGADOR WEB: http://$IP_SERVER/
echo 'Usuário padrão: Admin (atenção ao case sensitive)'
echo 'senha padrão: zabbix'
echo
echo
echo PARA ACESSAR O GRAFANA INSIRA O SEGUINTE ENDEREÇO EM SEU NAVEGADOR WEB: http://$IP_SERVER:3000/
echo 'Usuário padrão: admin'
echo 'senha padrão: admin'
echo
echo INSIRA A SEGUINTE URL PARA SE CONECTAR AO ZABBIX A PARTIR DO GRAFANA: http://$IP_SERVER/api_jsonrpc.php
echo
echo
echo PARA ACESSAR O GRAYLOG INSIRA O SEGUINTE ENDEREÇO EM SEU NAVEGADOR WEB: http://$IP_SERVER:9000/
echo 'Usuário padrão: admin'
echo 'senha padrão: "definida durante o processo de instalação"'