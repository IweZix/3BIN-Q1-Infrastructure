### Créez un rôle ansible nommé deploy_nodejs_app_from_git. 
```
ansible-galaxy init [name]
```
archi
```
.
├── README.md
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

1. defaults/
Ce dossier contient les variables par défaut du rôle.
```
---
# defaults file for deploy_nodejs_app_from_git
nodejs: nodejs
npm: npm
repo: "https://github.com/olivierchoquet/exoplanets_infra.git"
dest: "./nodejs_app"
start: "npm start"
```

2. handlers/
Ce dossier contient les gestionnaires (handlers). Un handler est une tâche spéciale qui est exécutée uniquement lorsqu’il est déclenché par une autre tâche (via notify). 

3. meta/
Ce dossier contient des métadonnées sur le rôle, comme ses dépendances ou les informations le décrivant.
```
galaxy_info:
  author: Luca N.
  description: Deploy a Node.js app froma git repo
  company: HEVinci
```

4. tasks/
Ce dossier contient la liste principale des tâches exécutées par le rôle. Ces tâches définissent ce que fait le rôle.
```
---
# tasks file for deploy_nodejs_app_from_git
- name: Install nodejs
  apt:
    name: "{{ nodejs }}"
    state: latest

- name: Install npm
  apt:
    name: "{{ npm }}"
    state: latest

- name: Clone repo
  git:
    repo: "{{ repo }}"
    dest: "{{ dest }}"
    version: main

- name: Run npm install
  command: npm install
  args:
    chdir: "{{ dest }}"

- name: Run app
  command: "{{ start }}"
  args:
    chdir: "{{ dest }}"
```

5. files/
Ce dossier contient des fichiers statiques qui doivent être copiés tels quels sur la machine cible. Contrairement aux modèles, ils ne contiennent pas de variables ou de logique dynamique.

### playbook
```
- hosts: localhost
  gather_facts: true
  become: true

  roles:

  - role: deploy_nodejs_app_from_git
    vars:
      repo: "https://github.com/olivierchoquet/exoplanets_infra.git"
      dest: "./nodejs_app"
      start: "npm start"
