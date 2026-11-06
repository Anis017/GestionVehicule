# Réponses aux questions - TP Docker + Jenkins

### Question 1 : Quelle différence entre une image Docker et un conteneur ?
Une image est un modèle immuable et statique contenant les fichiers et configurations nécessaires ; un conteneur est une instance vivante créée et exécutée à partir de cette image[cite: 6].

### Question 2 : Pourquoi n'utilise-t-on pas `docker run -p 8080:8080` pour GestionVehicule ?
GestionVehicule est une application console sans serveur réseau. Elle n'écoute aucun port TCP/UDP, la redirection de port avec `-p` est donc inutile[cite: 6].

### Question 3 : Quelle est la différence entre `docker --version` et `docker version` ?
`docker --version` affiche uniquement la version du client CLI, tandis que `docker version` affiche les détails techniques du client ET du serveur (démon Docker)[cite: 6].

### Question 4 : À quoi servent les deux instructions `FROM` dans le Dockerfile ?
Le premier `FROM` (JDK) sert d'étape de compilation. Le second `FROM` (JRE) sert pour l'exécution finale sans embarquer les outils de compilation lourds et inutiles en production[cite: 6].

### Question 5 : Pourquoi ignorer `.git` et `out/` dans `.dockerignore` ?
Pour réduire le contexte de build envoyé au moteur Docker, accélérer la construction et éviter d'embarquer des fichiers compilés locaux ou l'historique de version[cite: 6].

### Question 6 : Pourquoi le conteneur s'arrête-t-il immédiatement après l'affichage ? Est-ce un échec ?
Non, ce n'est pas un échec. L'application se termine naturally une fois la méthode `main` exécutée. Le statut `Exited (0)` confirme une sortie réussie[cite: 6].

### Question 7 : Est-ce que `git push` publie l'image dans Docker Hub ?
Non. `git push` envoie le code source vers GitHub. Pour publier une image sur un registre Docker, il faut utiliser la commande `docker push`[cite: 6].

### Question 8 : Que se passe-t-il si les tests JUnit échouent ? Jenkins construit-il quand même l'image ?
Non. Dans un pipeline séquentiel, un échec lors de l'étape des tests JUnit stoppe l'exécution et Jenkins ne passe pas à l'étape `docker build`[cite: 6].

### Question 9 : Pourquoi Docker fonctionne-t-il dans mon terminal mais pas toujours dans Jenkins ?
L'utilisateur système `jenkins` possède des droits et groupes séparés. S'il n'appartient pas au groupe `docker`, l'accès au socket `/var/run/docker.sock` lui est refusé[cite: 6].

### Question 10 : Quel est l'intérêt du tag `gestionvehicule:ci-${BUILD_NUMBER}` ?
Il permet de différencier et de tracer les images générées à chaque build de Jenkins, facilitant l'identification et le rollback[cite: 6].

### Question 11 : Pourquoi les tests JUnit restent-ils verts alors que le pipeline devient rouge lors d'une erreur dans ENTRYPOINT ?
Les tests JUnit valident le code Java, mais l'instruction `ENTRYPOINT` est testée uniquement lors de l'exécution du conteneur avec `docker run`[cite: 6].

### Question 12 : Docker garantit-il automatiquement que le programme ne contient aucun bug ?
Non. Docker garantit l'isolation et la reproductibilité de l'environnement d'exécution, mais pas la qualité logique du code applicatif[cite: 6].
