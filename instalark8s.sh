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
  echo "==============================="
  exit
fi

echo "==============================="
echo " Rol:    "$rol
echo " Nombre: "$nombre
echo "==============================="

sudo hostnamectl set-hostname $nombre
sudo apt update
sudo apt --assume-yes install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt --assume-yes install docker-ce
#el sigiente comando es solo para ver el estado
#sudo service docker status
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo swapoff -a
sudo apt-get --assume-yes install kubeadm -y
kubeadm version

# SOLO MASTER
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#guardar output para worker nodes
read -rsp $'Guardar SALIDA...\n'

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces
kubectl get nodes


# SOLO NODES
 # COMANDO DE SALIDA DEL MASTER!!!!
