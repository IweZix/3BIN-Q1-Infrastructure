Dockerfile

```
FROM debian

RUN apt-get update
RUN apt-get install -y apache2

COPY syllabusHTML /var/www/syllabusHTML
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

# FOREGROUND to start apache2 automatically in docker
CMD apachectl -D FOREGROUND
```

vhost.conf
```
<VirtualHost *:80>
        ServerName syllabusHTML

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/syllabusHTML
        ErrorLog ${APACHE_LOG_DIR}/syllabusHTML_error.log
        CustomLog ${APACHE_LOG_DIR}/syllabusHTML_access.log combined

        <Directory /var/www/syllabusHTML>
        Require all granted
        AllowOverride All
        </Directory>
</VirtualHost>
```

nano /etc/hosts
```
...
127.0.0.1   syllabusHTML  
...
```


docker-compose.yaml
```
services:
  exercice1:
    build:
      context: .
    ports:
      - "8091:80"
```

Lancer le site
```
lynx syllabusHTML
```