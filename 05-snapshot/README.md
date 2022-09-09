# Armando el directorio de trabajo

Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 05-snapshot
cd 05-snapshot
```

# Como evitar levantar una VM de cero

Al levantar una VM de cero cuando tenemos configurados provisioners nos genera un overhead porque tiene que actualizar todos los paquetes. Una forma de evitar esto es usando el comando [vagrant snapshot](https://www.vagrantup.com/docs/cli/snapshot).

Este comando nos permite generar un snapshot de la VM, luego de eso podemos aplicarle varios cambios y en caso de ser necesario restaurarlo al snapshot inicial.

Para generar un snapshot podemos usar `vagrant snapshot push`:

```
vagrant snapshot push
==> default: Snapshotting the machine as 'push_1662649301_1327'...
==> default: Snapshot saved! You can restore the snapshot at any time by
==> default: using `vagrant snapshot restore`. You can delete it using
==> default: `vagrant snapshot delete`.
```

Y para restaurarlo, podemos usar `vagrant snapshot pop`:

```
vagrant snapshot pop
==> default: Forcing shutdown of VM...
==> default: Restoring the snapshot 'push_1662649301_1327'...
==> default: Deleting the snapshot 'push_1662649301_1327'...
==> default: Snapshot deleted!
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Resuming suspended VM...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 172.28.32.1:2222
    default: SSH username: vagrant       
    default: SSH auth method: private key
==> default: Machine booted and ready!
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
```

Al correr `vagrant snapshot pop` por default se borrar el snapshot que se genero, para evitar esto se puede usar el flag `--no-delete`
