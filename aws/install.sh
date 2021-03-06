#!/bin/bash

kubectl create namespace sysdigcloud 
kubectl create -f etc/sdc-config.yaml 
kubectl create -R -f datastores/storageclasses/

openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj "/C=US/ST=CA/L=SanFrancisco/O=ICT/CN=sysdig.yoftilabs.com" -keyout etc/certs/server.key -out etc/certs/server.crt
kubectl create secret tls sysdigcloud-ssl-secret --cert=etc/certs/server.crt --key=etc/certs/server.key --namespace=sysdigcloud

kubectl create -f datastores/sdc-mysql-master.yaml &
kubectl create -f datastores/sdc-redis-master.yaml &
kubectl create -f datastores/sdc-redis-slaves.yaml &
kubectl create -f datastores/sdc-cassandra.yaml & 
kubectl create -f datastores/sdc-elasticsearch.yaml &
sleep 30
echo "starting mysql-slaves"
kubectl create -f datastores/sdc-mysql-slaves.yaml &

sleep 60
kubectl create -R -f backend/

echo
echo "app started ..."
echo






