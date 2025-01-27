# Utilise l'image officielle Python 3.13.0 sur Alpine Linux 3.20
FROM python:3.13.0-alpine3.20

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie le script sum.py dans le répertoire /app
COPY sum.py /app/

# Commande par défaut pour que le conteneur reste actif
CMD ["tail", "-f", "/dev/null"]
