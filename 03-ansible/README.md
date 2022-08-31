# Armando el directorio de trabajo

Para empezar esta parte primero creeamos una carpeta dedicada a tener los files que se vayan a usar

```
mkdir 03-ansible
cd 03-ansible
```

# Como correr playbooks de ansible

[Ansible](https://docs.ansible.com/ansible/latest/user_guide/index.html) es una herramienta de configuration management basada en el paradigma declarativo, es decir, se dice lo que se quiere y no como llegar a ese resultado. Esto permite armar tareas [idempotentes](https://es.wikipedia.org/wiki/Idempotencia#:~:text=En%20matem%C3%A1tica%20y%20l%C3%B3gica%2C%20la,elemento%20idempotente%2C%20o%20un%20idempotente).

Vagrant permite integrar al proceso de aprovisionado de VMs la ejecución de playbooks de Ansible. Para probar esto, primero vamos a crear una playbook bastante sencilla que permita asegurarnos que el servicio de apache está instalado y corriendo.

Crear un file `playbook.yml`

```
---

- name: Simple playbook
  hosts: all
  handlers:
    - name: Restart apache
      ansible.builtin.service:
        name: apache2
        state: restarted
  tasks:
    - name: Install apache
      ansible.builtin.apt:
        name: apache2
        state: present
      become: true
      become_user: root
```

Luego, similar al shell provisioner, se le puede decir a vagrant que corra una playbook usando el [ansible provisioner](https://www.vagrantup.com/docs/provisioning/ansible) y agregando la siguiente linea al Vagranfile

```
  config.vm.provision "ansible" do |ansible| 
    ansible.playbook="playbook.yml" 
```

Y levantar la VM usando `vagrant up --provision` o `vagrant provision`