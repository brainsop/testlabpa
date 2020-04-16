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

#validacion de parametro master o worker
if [ $rol != 'master' ] && [ $rol != 'worker' ]
then
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

#lo sigioente es comun a ambos al master como al worker node
sudo hostnamectl set-hostname $nombre
sudo apt update
sudo apt --assume-yes install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt --assume-yes install docker-ce
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo swapoff -a
sudo apt-get --assume-yes install kubeadm -y
kubeadm version


if [ $rol == 'master' ]
then
  # SOLO MASTER
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16

  #guardar output para worker nodes
  #TODO: guardar output y dejarlo en un file para poder armar el comando de ejecucion en el worker node
  read -rsp $'Guardar SALIDA del MASTER (dos lineas anteriores) y presionar Enter ...\n'

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  kubectl get pods --all-namespaces
  kubectl get nodes

else
  # SOLO WORKER NODES
  echo "==============================="
  echo
  echo "  Listo!"
  echo "   Lo unico que falta es que ejecute el comando de join del worker al Master de K8"
  echo "   Copie y ejecute el archivo jointocluster.sh que esta en el Master y ejecute"
  echo "   el mismo en el nodo para agegar el mismo"
  echo
  echo "==============================="
fi
