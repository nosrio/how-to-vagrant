# Bootstrap
Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 01-hello-world
cd 01-hello-world
```

# [Vagrant init](https://www.vagrantup.com/docs/cli/init)

Este comando permite crear un Vagrantfile inicial para levantar un VM especifica. Se pueden buscar distintas boxes en [vagrant cloud](https://app.vagrantup.com/boxes/search)

```
vagrant init hashicorp/bionic64
```

Se pueden usar los siguientes flags en este comando

```
-m Crea un vagrantfile sin comentarios.
    vagrant init -m hashicorp/bionic64
```

```
--box-version Fuerza el vagrantfile para una version especifica.
    vagrant init --box-version '> 0.1.5' hashicorp/bionic64
```

# Vagrantfile

La sintaxis de este file es ruby y describe las configuraciones de virtualbox para levantar la VM.

# [Vagrant.configure](https://www.vagrantup.com/docs/vagrantfile/version)

Asi arrancan los vagrantfile y dentro se agregan todas las configuraciones pertinentes.
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

Cada setting que tiene virtualbox se puede tunear dentro del configure. En el caso de Windows+WSL para que levanté hay que agregar los siguientes settings:

```
  # Desconecta el puerto serie por https://www.virtualbox.org/ticket/18319
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected"]
  end
```