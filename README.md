# devops-lab-api-python-flask

Simple API Flask containerisée (Docker) et déployée sur une EC2 via GitHub Actions.

## Endpoints
- `GET /` → `Hello DevOps`

## Port
- API exposée sur `8080`

## Déploiement local env
```bash
docker build -t flask-api .
docker run --rm -p 8080:8080 flask-api
curl -i http://localhost:8080/

