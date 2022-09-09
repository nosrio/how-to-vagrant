# Armando el directorio de trabajo

Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 04-docker
cd 04-docker
```

# Como integrar docker con vagrant

Vagrant cuenta con un tipo de [provisioner especial](https://www.vagrantup.com/docs/provisioning/docker) que permite instalar docker en la VM a levantar e incluso ejecutar ciertas tareas al momento de levantar la VM. Para levantar una VM con docker instalado hay que agregar la siguiente linea al Vagrantfile.

```
  config.vm.provision :docker
```

Al correr `vagrant up --provision`

```
vagrant up --provision
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'hashicorp/bionic64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Setting the name of the VM: 04-docker_default_1662729730841_16560
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 172.28.32.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection reset. Retrying...
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
==> default: Mounting shared folders...
    default: /vagrant => /mnt/c/Users/Nicolas.Osorio/Documents/code/how-to-vagrant/04-docker
==> default: Running provisioner: docker...
    default: Installing Docker onto machine...
```

# Como buildear un dockerfile

Este provisioner también permite levantar una VM y buildear un Dockerfile durante el bootstrap. Para eso primero tenemos que crear un archivo sencillo llamado `Dockerfile` y agregarle el siguiente contenido.

```
FROM alpine
CMD ["echo", "Hola Mundo!"]
```

Este dockerfile tomara como base una imagen de `alpine` y al levantar imprimira por pantalla un "Hola mundo!". Para decirle a Vagrant que buildee esta imagen hay que agregar las siguientes lineas.

```
  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/"
  end
```

En este caso la ruta del comando build_image se seteo como el volumen local que Vagrant monta en la VM. Puede setearse otra ruta o montar otro volumen. Al correr `vagrant up --provision`.

```
vagrant up --provision
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Running provisioner: docker...
==> default: Building Docker images...
==> default: -- Path: /vagrant/
==> default: Sending build context to Docker daemon   25.6kB
==> default: Step 1/2 : FROM alpine
==> default: latest: Pulling from library/alpine
==> default: 213ec9aee27d: Pulling fs layer
==> default: 213ec9aee27d: Verifying Checksum
==> default: 213ec9aee27d: Download complete
==> default: 213ec9aee27d: Pull complete
==> default: Digest: sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
==> default: Status: Downloaded newer image for alpine:latest
==> default:  ---> 9c6f07244728
==> default: Step 2/2 : CMD ["echo", "Hello StackOverflow!"]
==> default:  ---> Running in 6e4c2521a21e
==> default: Removing intermediate container 6e4c2521a21e
==> default:  ---> 88b20c5644f3
==> default: Successfully built 88b20c5644f3
```

Para ver la imagen recién creada podemos conectarnos a la VM usando `vagrant ssh` y dentro de la misma correr un `docker images`.

```
docker images
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
<none>       <none>    88b20c5644f3   2 minutes ago   5.54MB
```

# Como levantar un contenedor dentro de la VM

Finalmente para que luego de buildear la imagen el conteneder quede corriendo se puede modificar la linea anterior de esta manera:

```
  config.vm.provision "docker" do |d|
    d.build_image '/vagrant/.', args: '-t hola-mundo'
    d.run 'hola-mundo'
  end
```

El argumento `-t` nos permite tagear la imagen recién creada para referenciarla despues. Lo cual nos da la siguiente salida al correr `vagrant up --provision`:

```
vagrant up --provision
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Running provisioner: docker...
==> default: Building Docker images...
==> default: -- Path: /vagrant/.
==> default: Sending build context to Docker daemon  27.14kB
==> default: Step 1/2 : FROM alpine
==> default: 
==> default:  ---> 9c6f07244728
==> default: Step 2/2 : CMD ["echo", "Hello StackOverflow!"]
==> default:  ---> Using cache
==> default:  ---> 88b20c5644f3
==> default: Successfully built 88b20c5644f3
==> default: Successfully tagged hola-mundo:latest
==> default: Starting Docker containers...
==> default: -- Container: hola-mundo
```

Para validar el correcto funcionamiento del mismo podemos hacer `vagrant ssh` y corriendo `docker ps` podemos ver que el contenedor está creado.

```
docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS                          PORTS     NAMES
de74ebe5212e   hola-mundo   "echo 'Hello StackOv…"   2 minutes ago   Restarting (0) 26 seconds ago             hola-mundo
```

Además con el CONTAINER ID se puede usar el comando `docker logs <CONTAINER ID>` para ver la salida.

```
docker logs de74ebe5212e
Hello StackOverflow!
```

# Como exponer el contenedor al mundo

Para la última demo, vamos a usar una imagen pública del hub de docker llamado [dockersamples/static-site](https://hub.docker.com/r/dockersamples/static-site/). Está imagen simplemente levanta un sitio estatico. Sin embargo, para poder acceder al sitio dentro del contenedor, dentro de la VM tenemos que exponer los puertos. Para ello, debemos configurar el Vagrantfile de la siguiente manera.

```
  config.vm.provision "docker" do |d|
    d.run "hola-mundo", image: "dockersamples/static-site", args: "-p 8080:80"
  end
  config.vm.network "forwarded_port", guest: 8080, host: 8080
```

El comando `run` recibe como primer argumento un nombre para identificar el contenedor, el parametro `image` es la imagen que vamos a correr y el tercer parametro son argumentos adicionales que se pueden pasar a `docker run`. En este caso el flag `-p` me permite exponer el puerto `80` del contenedor y lo natea al puerto `8080` de la VM.

La segunda linea, `config.vm.network`, me permite natear un puerto de la VM al host. En este caso, expongo el puerto `8080` de la VM al puerto `8080` del host.

Si ya tenemos la VM arriba, tenemos que usar el comando `vagrant reload --provision` para que tome la configuración del nuevo nateo y luego ejecuté el provisioner de dokcer.

```
vagrant reload
==> default: Attempting graceful shutdown of VM...
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 8080 (guest) => 8080 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 172.28.32.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
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
==> default: Mounting shared folders...
    default: /vagrant => /mnt/c/Users/Nicolas.Osorio/Documents/code/how-to-vagrant/04-docker
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Running provisioner: docker...
==> default: Building Docker images...
==> default: -- Path: /vagrant/.
==> default: Sending build context to Docker daemon  27.14kB
==> default: Step 1/2 : FROM alpine
==> default: 
==> default:  ---> 9c6f07244728
==> default: Step 2/2 : CMD ["echo", "Hello StackOverflow!"]
==> default:  ---> Using cache
==> default:  ---> 88b20c5644f3
==> default: Successfully built 88b20c5644f3
==> default: Successfully tagged hola-mundo:latest
==> default: Starting Docker containers...
==> default: -- Container: hola-mundo
```

Ahora podemos acceder desde un navegador del host a la URL http://localhost:8080 y podremos ver el sitio corriendo dentro de docker dentro de la VM mostrando la siguiente leyenda

```
Hello Docker!
This is being served from a docker
container running Nginx.
```