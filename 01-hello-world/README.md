# Armando el directorio de trabajo

Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 01-hello-world
cd 01-hello-world
```

# Como generar un Vagrantfile

El comando [vagrant init](https://www.vagrantup.com/docs/cli/init) permite crear un Vagrantfile inicial para levantar un VM especifica. Dicho file tiene varias configuraciones que se veran más adelante. 

El Vagrantfile inicial parte de una "box" o imagen base. Se pueden buscar distintas boxes en [vagrant cloud](https://app.vagrantup.com/boxes/search)

```
vagrant init hashicorp/bionic64
```

Adicionalmente se pueden usar los siguientes flags en este comando

```
-m Crea un vagrantfile sin comentarios.
    vagrant init -m hashicorp/bionic64
```

```
--box-version Fuerza el vagrantfile para una version especifica.
    vagrant init --box-version '> 0.1.5' hashicorp/bionic64
```

# Como especificar la imagen base

La sintaxis del Vagrantfile esta basanda en ruby y describe un conjunto de configuraciones al momento de  levantar la VM. Pueden verse más detalles de como configurarlo [acá](https://www.vagrantup.com/docs/vagrantfile/version).

Con la directiva `vagrant.configure` arrancan los vagrantfile y dentro se agregan todas las configuraciones pertinentes.
```
Vagrant.configure("2") do |config|
  # ...
end
```

Por ejemplo, se puede especificar el S.O. y la version de dicho box desde la cual parten seteando los parametros `vm.box` y `vm.box_version`.

```
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.box_version = "1.0.282"
end
```

Cada setting que tiene virtualbox (o otros virtualizadores) se puede tunear dentro del configure. En el caso de Windows+WSL para que levanté hay que agregar los siguientes settings:

```
  # Desconecta el puerto serie por https://www.virtualbox.org/ticket/18319
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected"]
  end
  # Desactivo carpeta compartida entre vagrant y host
  config.vm.synced_folder ".", "/vagrant", disabled: true
```

# Como levantar una VM

Una vez que el Vagrantfile está configurado, corriendo el comando [vagrant up](https://www.vagrantup.com/docs/cli/up) se aprovisiona la VM.

```
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'hashicorp/bionic64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Setting the name of the VM: 01-hello-world_default_1661290327917_45108
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 172.22.240.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection reset. Retrying...
    default: Warning: Remote connection disconnect. Retrying...
    default: 
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default: 
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default:
    default: Guest Additions Version: 6.0.10
    default: VirtualBox Version: 6.1
```

# Como conectarse a la VM

Una vez que la instancia termina de levantar, podemos conectarnos a la misma via ssh usando el comando [vagrant ssh](https://www.vagrantup.com/docs/cli/ssh)


```
vagrant ssh
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-58-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Aug 24 02:32:27 UTC 2022

  System load:  1.26              Processes:           121
  Usage of /:   2.5% of 61.80GB   Users logged in:     0
  Memory usage: 5%                IP address for eth0: 10.0.2.15
  Swap usage:   0%

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

0 packages can be updated.
0 updates are security updates.
```

# Como apagar la VM

Una vez finalizada las pruebas puede detenerse la VM usando [vagrant halt](https://www.vagrantup.com/docs/cli/halt).

```
vagrant halt
==> default: Attempting graceful shutdown of VM...
```

# Como destruir la VM

O destruirse usando [vagrant destroy](https://www.vagrantup.com/docs/cli/destroy).

```
vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...
```