
## Exercice 1
Le but de cet exercice est de déployer 3 conteneurs avec la même application NodeJs et d’installer ensuite via Apache un load balancer permettant de répartir les requêtes vers ces 3 conteneurs.

1.    Déployez via docker-compose 3 conteneurs de l’application nodejs_ipshow
a.    Vous trouverez sur MooVin un zip contenant l’application.
b.    Compléter le fichier Dockerfile et docker compose
```
FROM node:14

WORKDIR /usr/src/app

COPY . .

RUN npm install

EXPOSE 3000

CMD ["node", "index.js"]
```

```
version: "3"
services:
  ipshow1:
    build: .
    ports:
      - "3001:3000"
  ipshow2:
    build: .
    ports:
      - "3002:3000"
  ipshow3:
    build: .
    ports:
      - "3003:3000"
```
c.    Vous êtes libre de choisir vos ports.

2.    Testez directement deux de vos conteneurs
a.    lynx http://localhost:<port_choisi>
b.    Vous voyez l’IP du conteneur
c.    Les adresses IP des 3 conteneurs doivent être normalement légèrement différentes !

3.    Consultez la section 6.10 du syllabus consacré à l’installation d’un load balancer dans Apache.

4.    Implémentez le load balancer Apache directement dans votre Debian Azure
a. Création d'un vhost pour le nouveau site dans /etc/apache2/sites-available
```
<VirtualHost *:80>
    ServerName nodejs_ipshow
    ServerAdmin webmaster@localhost
    
    ProxyPreserveHost On

    <Proxy "balancer://mycluster">
        BalancerMember http://localhost:3001
        BalancerMember http://localhost:3002
        BalancerMember http://localhost:3003
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
b. routage des ip dans /etc/hosts
```
nano /ets/hosts
```

```
127.0.0.1   nodejs_ipshow
```

5.    Résultat attendu :
a.    lynx [http://nodejs_ipshow](http://nodejs_ipshow) affiche l’IP de conteneur. En rafraichissant (en relançant lynx), l’IP change car les requêtes sont balancées entre les 3 conteneurs.