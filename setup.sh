apt update
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt update
apt install docker-ce -y
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
rm -r monitoramento2/
docker rm -f $(docker ps -a -q)
docker volume prune --force
git clone https://github.com/mirandait-services/monitoramento2
#read -p 'Por gentileza insira o endereço IP ou URL que sera utilizada para acesso ao Graylog: ' IP_SERVER
#echo IP_SERVER=http://$IP_SERVER:9000/ > monitoramento2/var.env
IP_SERVER=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
echo IP_SERVER=http://$IP_SERVER:9000/ > monitoramento2/var.env
RANDOMPEPPER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo RANDOMPEPPER=$RANDOMPEPPER >> monitoramento2/var.env
clear
echo Por gentileza insira a senha de acesso ao Graylog Server:
GRAYLOG_PASSWORD=$(echo && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1)
echo GRAYLOG_PASSWORD=$GRAYLOG_PASSWORD >> monitoramento2/var.env
docker-compose --env-file monitoramento2/var.env -f monitoramento2/docker-compose.yml up -d
IP_SERVER=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
echo > monitoramento2/var.env
echo
echo "Aguarde enquanto as configurações personalizadas do ambiente são aplicadas"
sleep 1m
clear
echo
echo
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
echo
echo PARA ACESSAR O GRAYLOG INSIRA O SEGUINTE ENDEREÇO EM SEU NAVEGADOR WEB: http://$IP_SERVER:9000/
echo 'Usuário padrão: admin'
echo 'senha padrão: "definida durante o processo de instalação"'
echo
