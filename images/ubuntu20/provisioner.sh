#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo addgroup docker
sudo adduser vagrant docker


docker run \
>   --name jenkins-blueocean \
>   --restart=on-failure \
>   --detach \
>   --network jenkins \
>   --env DOCKER_HOST=tcp://docker:2376 \
>   --env DOCKER_CERT_PATH=/certs/client \
>   --env DOCKER_TLS_VERIFY=1 \
>   --publish 8080:8080 \
>   --publish 50000:50000 \
>   --volume jenkins-data:/var/jenkins_home \
>   --volume jenkins-docker-certs:/certs/client:ro \
>   jenkins/jenkins

#python3 -m pip install --upgrade pip 
#python3 -m pip install --user ansible