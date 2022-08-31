# Armando el directorio de trabajo

Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 02-shell
cd 02-sheel
```

# Como montar una carpeta local en la VM

Por default, vagrant monta en el directorio `/vagrant/` de la VM el directorio donde está creado el Vagrantfile. Para activar esta feature hay que remover la siguiente linea del Vagrantile que tenemos.

```
  config.vm.synced_folder ".", "/vagrant", disabled: true
```

Adicionalmente, se puede usar esta config para montar otros [directorios](https://www.vagrantup.com/docs/synced-folders).

# Como correr un script al crear una VM
s
Vagrant tiene varios provisioners que permite ejecutar varias acciones al momento de aprovisionar la VM. El [shell provisioner](https://www.vagrantup.com/docs/provisioning/shell) permite correr un script. Para esto, como primer paso vamos a crear un file `provisioner.sh`

## Crear un script

```
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install python3-pip python3-dev libffi-dev libssl-dev git -y
python3 -m pip install --upgrade pip 
python3 -m pip install --user ansible
```

La variable `DEBIAN_FRONTEND` es para evitar un warning al momento de instalar paquetes usando apt-get. Luego de eso nos aseguramos de tener instalado python3, pip y ansible

## Correr el script

Para poder correr el script recién creado debe agregarse la siguiente linea al Vagrantfile

```
  config.vm.provision "shell", path: "provisioner.sh"
```

Y luego pueden usarse los comandos `vagrant up --provision` o `vagrant provision` para que se ejecute este script durante el aprovisionamiento de la VM.

## Correr script sin privilegios

Para evitar los warning del tipo `Running pip as the 'root' user can result in broken permissions`, hay que setear el flag de `privileged` en false.

```
  config.vm.provision "shell", path: "provisioner.sh", privileged: false
```