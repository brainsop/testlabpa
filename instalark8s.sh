#!/bin/bash

# tomo por parametro 
rol=$1
nombre=$2

# si no recive los parametros adecuados 
if [ $# -lt 2 ]; then
  echo
  echo "==============================="
  echo
  echo "  Instalar K8s no recibio los parametros adecuados. Debe recibir:"
  echo
  echo "    ./instalark8s.sh rol nombre"
  echo
  echo "  opciones validas:"
  echo "    rol = master o worker"
  echo "    nombre = nombre de host a usar"
  echo
  echo " rol "$rol
  echo " nombre "$nombre
  echo "==============================="
  exit
fi

echo "==============================="
echo " Rol:    "$rol
echo " Nombre: "$nombre
echo "==============================="

sudo hostnamectl set-hostname $nombre

read -rsp $'Press enter to continue...\n'

sudo apt update

read -rsp $'Press enter to continue...\n'

sudo apt install apt-transport-https ca-certificates curl software-properties-common

read -rsp $'Press enter to continue...\n'

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add

read -rsp $'Press enter to continue...\n'

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

read -rsp $'Press enter to continue...\n'

sudo apt update

read -rsp $'Press enter to continue...\n'

apt-cache policy docker-ce

read -rsp $'Press enter to continue...\n'

sudo apt install docker-ce

read -rsp $'Press enter to continue...\n'

sudo service docker status

read -rsp $'Press enter to continue...\n'

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

read -rsp $'Press enter to continue...\n'

sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

read -rsp $'Press enter to continue...\n'

sudo swapoff -a

read -rsp $'Press enter to continue...\n'

sudo apt-get install kubeadm -y

read -rsp $'Press enter to continue...\n'

kubeadm version

read -rsp $'Press enter to continue...\n'

# SOLO MASTER
kubeadm init —pod-network-cidr=10.244.0.0/16
#guardar output para worker nodes

read -rsp $'Guardar SALIDA...\n'
read -rsp $'Press enter to continue...\n'

mkdir -p $HOME/.kube

read -rsp $'Press enter to continue...\n'

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

read -rsp $'Press enter to continue...\n'

sudo chown $(id -u):$(id -g) $HOME/.kube/config

read -rsp $'Press enter to continue...\n'

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

read -rsp $'Press enter to continue...\n'

kubectl get pods --all-namespaces

read -rsp $'Press enter to continue...\n'

kubectl get nodes

read -rsp $'Press enter to continue...\n'

# SOLO NODES
 # COMANDO DE SALIDA DEL MASTER!!!!
