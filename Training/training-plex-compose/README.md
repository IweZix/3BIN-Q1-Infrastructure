# Training-plex-compose

## Énoncé

Création d'un fichier docker-compose.yml pour déployer un Plex Media Server

## Objectif

Vous devez créer un fichier docker-compose.yml pour déployer un Plex Media Server avec Docker. Ce serveur doit être configuré pour permettre la gestion de fichiers multimédias et leur diffusion en continu via une interface web.

## Contraintes

1. Utiliser l'image de plex maintenue par linuxserver.io :
    - [linuxserver/plex](https://hub.docker.com/r/linuxserver/plex)

2. Congigurer les volumes media et config :
    - Pas besoin d'avoir de media et de config pour le moment, vous pouvez laisser le volume vide

3. Configurer les ports
    - Le port 32400 doit être exposé pour accéder à l'interface web
    - Les ports supplémentaires ne sont pas nécessaires pour le moment
    - Vous aurez besoin de faire quelque en plus pour accéder à l'interface web depuis votre navigateur (safari, chrome, firefox, etc.)

4. Configurater un redémarrage automatique
    - Le container doit redémarrer automatiquement en cas d'erreur

5. Vous ne pouvez pas utiliser la command ``lynx`` durant cet exercice
