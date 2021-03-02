rm -r monitoramento/
docker rm -f $(docker ps -a -q)
docker volume prune --force
git clone https://github.com/binariocloud/monitoramento
chmod +x monitoramento/setup.sh
./monitoramento/setup.sh