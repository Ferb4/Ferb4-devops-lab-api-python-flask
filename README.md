# DevOps Lab AWS - Terraform + Docker + GitHub Actions + ECR

## Objectif du laboratoire

L'objectif de ce projet est de mettre en place une chaîne CI/CD complète sur AWS afin de comprendre les fondamentaux du DevOps.

À la fin du laboratoire, un simple `git push` permet de :

1. Construire une image Docker.
2. Publier l'image dans AWS ECR.
3. Se connecter à une instance EC2.
4. Télécharger la nouvelle image.
5. Redémarrer automatiquement l'application.

---

# Architecture

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ▼
AWS ECR
    │
    ▼
EC2
    │
    ▼
Docker
    │
    ▼
Application
```

---

# Concepts DevOps étudiés

## Infrastructure as Code (IaC)

L'Infrastructure as Code consiste à décrire l'infrastructure dans du code plutôt que de la créer manuellement.

Exemple :

```hcl
resource "aws_instance" "lab" {
  instance_type = "t3.micro"
}
```

Au lieu de cliquer dans la console AWS :

* Terraform crée l'instance.
* Terraform la modifie.
* Terraform la détruit.

Avantages :

* Reproductible
* Versionnable
* Automatisable
* Auditable

---

## Terraform

Terraform est un outil d'Infrastructure as Code.

Commandes principales :

### Initialiser

```bash
terraform init
```

Télécharge les providers nécessaires.

---

### Vérifier la configuration

```bash
terraform validate
```

Vérifie la syntaxe.

---

### Prévisualiser les changements

```bash
terraform plan
```

Montre ce qui sera créé.

Toujours lire le plan avant un apply.

---

### Créer l'infrastructure

```bash
terraform apply
```

Crée réellement les ressources AWS.

---

### Détruire l'infrastructure

```bash
terraform destroy
```

Supprime toutes les ressources gérées par Terraform.

Important :

Toujours détruire les ressources de laboratoire afin d'éviter des coûts AWS.

---

# AWS EC2

EC2 est un serveur virtuel dans AWS.

Dans ce laboratoire :

* Debian 12
* Docker installé automatiquement
* Accès SSH

---

# Security Group

Un Security Group est un pare-feu AWS.

Ports ouverts :

### SSH

```text
22/TCP
```

Permet la connexion distante.

---

### Application

```text
8080/TCP
```

Permet d'accéder à l'application.

---

# User Data

Le User Data est un script exécuté au premier démarrage de la machine.

Exemple :

```bash
#!/bin/bash

apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
```

Objectif :

Automatiser la configuration de la machine.

---

# Docker

Docker permet d'exécuter une application dans un conteneur.

---

## Construire une image

```bash
docker build -t mon-api .
```

---

## Lancer un conteneur

```bash
docker run -d -p 8080:8080 mon-api
```

---

## Voir les conteneurs

```bash
docker ps
```

---

## Voir les logs

```bash
docker logs <container>
```

---

## Supprimer un conteneur

```bash
docker rm -f <container>
```

---

# Amazon ECR

ECR signifie :

Elastic Container Registry.

C'est le registre Docker privé d'AWS.

Il stocke les images Docker.

Architecture :

```text
Docker Build
      │
      ▼
AWS ECR
      │
      ▼
EC2 Docker Pull
```

---

# IAM

IAM permet de gérer les permissions AWS.

Principe :

```text
Utilisateur
Rôle
Politique
```

---

## Rôle IAM EC2

Dans ce laboratoire :

L'instance EC2 possède un rôle IAM.

Permission :

```text
AmazonEC2ContainerRegistryReadOnly
```

Cela permet à Docker de récupérer des images depuis ECR sans stocker de clés AWS sur le serveur.

Bonne pratique importante.

---

# GitHub Actions

GitHub Actions permet d'automatiser des tâches.

Le workflow est défini dans :

```text
.github/workflows/deploy.yml
```

---

# CI (Continuous Integration)

À chaque push :

```text
git push
    │
    ▼
Build Docker
    │
    ▼
Tests
```

Objectif :

Valider automatiquement le code.

---

# CD (Continuous Delivery / Deployment)

Après le build :

```text
Build
   │
   ▼
Push ECR
   │
   ▼
Déploiement EC2
```

Objectif :

Automatiser la livraison.

---

# Secrets GitHub

Les secrets sont des variables protégées.

Exemples :

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
EC2_HOST
EC2_USER
EC2_SSH_PRIVATE_KEY
```

Ils ne doivent jamais être commités dans Git.

---

# Environnements GitHub

Exemple :

```text
dev
staging
prod
```

Chaque environnement peut avoir :

* ses secrets
* ses validations
* ses approbations

Dans ce laboratoire :

```text
test
```

---

# Déroulement complet du pipeline

Étape 1

```text
Developer
    │
    ▼
git push
```

---

Étape 2

```text
GitHub Actions démarre
```

---

Étape 3

```text
Docker Build
```

Création de l'image.

---

Étape 4

```text
Push ECR
```

Publication de l'image.

---

Étape 5

```text
SSH vers EC2
```

Connexion au serveur.

---

Étape 6

```text
Docker Pull
```

Téléchargement de la nouvelle version.

---

Étape 7

```text
Docker Stop
Docker Remove
Docker Run
```

Déploiement de la nouvelle version.

---

# Commandes utiles

## Vérifier l'état Terraform

```bash
terraform state list
```

---

## Connexion SSH

```bash
ssh -i ~/.ssh/id_ed25519 admin@IP_PUBLIQUE
```

---

## Vérifier Docker

```bash
docker ps
```

---

## Vérifier l'image ECR

```bash
aws ecr list-images \
  --repository-name devops-lab-api
```

---

## Vérifier le workflow

GitHub

Actions

Build Push and Deploy

---

# Ce que j'ai appris

* Terraform
* Infrastructure as Code
* AWS EC2
* Security Groups
* Docker
* AWS ECR
* IAM
* GitHub Actions
* CI/CD
* SSH
* Déploiement automatisé

---

# Prochaines étapes

Après ce laboratoire :

1. Backend Terraform S3 + DynamoDB
2. Multi-environnements dev/staging/prod
3. ECS
4. OpenTelemetry
5. Grafana
6. Loki
7. Mimir
8. GitOps
9. ArgoCD
10. Kubernetes

Ce laboratoire constitue la base de toutes les compétences DevOps modernes.
