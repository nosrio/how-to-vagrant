# Indice  
[Linux](#linux)  
[Windows](#windows)

## Linux

### Instalar virtualbox

```
sudo apt update
sudo apt install virtualbox
```

### Instalar vagrant

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant
vagrant --version
```
## Windows

Para poder correr vagrant en windows se necesita tener instalado WSL. La documentación que seguí es [esta](https://blog.thenets.org/how-to-run-vagrant-on-wsl-2/).

### Instalar virtualbox

 Descargar la última versión de [virtualbox](https://virtualbox.org/wiki/Downloads)

### Instalar WSL

[Documentación oficial](https://docs.microsoft.com/es-es/windows/wsl/install).

```
# Abrir powershell como administrador
wsl --install
```
La versión de WSL debe ser 2.
```
wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

### Instalar powershell 7 preview

```
# Abrir powershell como administrador

Invoke-Expression "& { $(Invoke-Restmethod https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
```

### Instalar Vagrant

Abrir WSL con Ubuntu20 o superior

```
# run inside WSL 2
# check https://www.vagrantup.com/downloads for more info
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant
```

Para habilitar el soporte de WSL2 hay que correr estos comandos.

```
# append those two lines into ~/.bashrc
echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> ~/.bashrc
echo 'export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/---Mi-usuario---/---carpeta-temporal"' >> ~/.bashrc
echo 'export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"' >> ~/.bashrc

# now reload the ~/.bashrc file
source ~/.bashrc
```

Y por último instalar [este plugin](https://github.com/Karandash8/virtualbox_WSL2)

```
# Install virtualbox_WSL2 plugin
vagrant plugin install virtualbox_WSL2
```