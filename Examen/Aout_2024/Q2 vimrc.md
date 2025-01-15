~/examen

Créer install_vim.yaml
```
---                                                                         - name: Playbook pour installer et configurer Vim                                hosts: localhost                                                            become: yes                                                                 tasks:                                                                        - name: Installer Vim                                                         apt:                                                                          name: vim                                                                   state: present                                                              update_cache: yes                                                                                             
       - name: Télécharger le fichier .vimrc et le placer dans /etc/skel             get_url:                                                                      url: https://gist.githubusercontent.com/simonista/8703722/raw               dest: /etc/skel/.vimrc                                                      mode: '0644'                                                                                                 
       - name: Vérifier que le fichier .vimrc est bien dans /etc/skel                stat:                                                                         path: /etc/skel/.vimrc                                                    register: vimrc_check                                                                                           
       - name: Message si .vimrc est absent                                          debug:                                                                       msg: "Le fichier .vimrc n'a pas été correctement téléchargé."              when: not vimrc_check.stat.exists  
```

Lancer ansible
```
ansible-playbook install_vim.yaml
```

Vérifier que le fichier soit bien télécharger 
```
ls -la /etc/skel
```

Créer un utilisateur
```
sudo adduser iwezix
```

Changer de user
```
su - iwezix
```

Tester
```
vim test.c
```

Si les numéros de lignes s'affiche c'est correct



