# Armando el directorio de trabajo

Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 06-kubernetes
cd 06-kubernetes
```

# Como levantar un cluster de kubernetes

Tome como ejemplo este [repositorio](https://github.com/lvthillo/vagrant-ansible-kubernetes) pero lo modifiqué para poder exponer el cluster a la red local.

El código de este Vagrantfile usa un par de playbooks de ansible para configurar un cluster de kubernetes con un master y un worker. Luego de correr `vagrant up` nos podemos logear al master usando `vagrant ssh k8s-master` y desde ahí usar `kubectl` para trabajar con el cluster. Además, el Vagrantfile expone el puerto 6443 al host, esto es necesario para poder conectarse con `kubectl` al cluster desde el exterior.

# Como conectarse al cluster desde el exterior

Para poder conectarse desde afuera, es necesario primero bajarse `kubectl`.

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Luego, para configurar el cluster nuevo, hay que traerse el kubeconfig del master.

```
scp -r vagrant@192.168.205.10:/home/vagrant/.kube .
cp -r .kube $HOME/
```

Podemos verificar que está todo bien usando `kubectl get nodes`.

```
kubectl get nodes
NAME         STATUS   ROLES                  AGE   VERSION
k8s-master   Ready    control-plane,master   22h   v1.23.0
node-1       Ready    <none>                 21h   v1.23.0
```