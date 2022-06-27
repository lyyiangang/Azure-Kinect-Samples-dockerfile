#!/usr/bin/env bash
# sudo docker build -t coin-trade . --build-arg HTTP_PROXY=http://10.210.41.142:8080  --build-arg HTTPS_PROXY=http://10.210.41.142:8080

source source.sh
ip_port="127.0.0.1:8889"
export http_proxy="http://${ip_port}"
export https_proxy="https://${ip_port}"
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy

# docker build -t $NAME_03 -f Dockerfile  --network host  .. 

docker build -t $NAME_03 -f Dockerfile .. 
#     --build-arg HTTP_PROXY=http://127.0.0.1:8889  --build-arg HTTPS_PROXY=http://127.0.0.1:8889