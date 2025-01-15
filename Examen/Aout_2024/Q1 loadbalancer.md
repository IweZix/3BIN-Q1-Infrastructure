
## Étape 1

~/examen

Ajouter ``index.php``
```
IP :   <?php echo $_SERVER['SERVER_ADDR'];?> <br>
PORT : <?php echo $_SERVER['SERVER_PORT'];?>
```

Ajouter ``Dockerfile``
```
FROM php:7.4-apache
COPY index.php /var/www/html/
EXPOSE 80
```

Lancer Docker
```
docker build -t phpapp .
docker run -d -p 80:80 --name phpapp phpapp
```

Lynx
```
lynx http://localhost
```


## Étape 2

~/examen

Ajouter ``docker-compose.yaml``
```
version: '3.8'

services:
  phpapp1:
    build: .
    ports:
      - "8001:80"
    container_name: phpapp1

  phpapp2:
    build: .
    ports:
      - "8002:80"
    container_name: phpapp2

  phpapp3:
    build: .
    ports:
      - "8003:80"
    container_name: phpapp3
```

Lancer Docker
```
docker-compose up -d
```

Lynx
```
lynx http://localhost:8001
lynx http://localhost:8002
lynx http://localhost:8003
```

## Étape 3

/etc/apache2/sites-available/loadbalancer.conf

Ajouter ``loadbalancer.conf``
```
<VirtualHost *:9000>
    ProxyRequests Off
    ProxyPreserveHost On

    <Proxy "balancer://phpcluster">
        BalancerMember http://localhost:8001
        BalancerMember http://localhost:8002
        BalancerMember http://localhost:8003
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass "/" "balancer://phpcluster/"
    ProxyPassReverse "/" "balancer://phpcluster/"

    ErrorLog ${APACHE_LOG_DIR}/loadbalancer_error.log
    CustomLog ${APACHE_LOG_DIR}/loadbalancer_access.log combined
</VirtualHost>
```

Forcer Apache à écouter sur le port 9000
```
sudo nano /etc/apache2/ports.conf
```

```
# If you just change the port or add more ports here, you will likely also  # have to change the VirtualHost statement in                               # /etc/apache2/sites-enabled/000-default.conf                                                                                       
Listen 80                                                                   Listen 9000                                                                                                                         
<IfModule ssl_module>                                                           Listen 443                                                              </IfModule>                                                                                                                         
<IfModule mod_gnutls.c>                                                         Listen 443                                                              </IfModule>   
```

```
sudo a2ensite loadbalancer.conf
```

```
sudo systemctl reload apache2
```





