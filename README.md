# python-api-poc-helm

This is a poc repo that builds a python API, accessible via HTTP, enabling search for specific US legal terms.

## Features

- **Simple HTTP API** for legal term lookup
- **Fully containerized** with Docker
- **Deployed and verified** in a Kubernetes cluster via Minikube
- **CI/CD** with automated testing, Docker builds, and local deployment validation

## Pre-requisites

To run or test this service locally, you'll need:

- **Python** 3.11
- **Poetry** 2.1.1 (for dependency management)
- **Docker** 28.0.4
- **Minikube** v1.35.0 (for Kubernetes testing)

## CI / CD Workflow

Every pull request:

- Ensures the Docker image builds successfully
- Runs all tests (`pytest`)

On merge to `main`:

- Builds and pushes the Docker image to [GitHub Packages](https://github.com/users/paulmarsicloud/packages/container/package/python-api-poc)
- Spins up a fresh Minikube instance on a GitHub Actions `ubuntu` runner
- Deploys and verifies that the API endpoints are live and functional

## Endpoints

| Method | Endpoint                    | Description                        |
|--------|-----------------------------|------------------------------------|
| GET    | `/terms`                    | Lists all available legal terms    |
| GET    | `/definitions?term=<term>`  | Returns the definition of a term  |

Example:
```bash
curl http://127.0.0.1:8000/definitions?term=person
```

## Local Testing

There are 3 ways to test this application

### Python only local testing

Run the following on your machine to test the python code directly:

```
poetry install --no-root
poetry run python -m src.api

# Go to your browser and test
http://127.0.0.1:8000/terms
http://127.0.0.1:8000/definitions?term=person
```

### Test in local Docker

Run the following on your machine to test that the _local_ Docker image works:

```
docker build -t python-api:latest .
docker run -p 8000:8000 python-api:latest

# Go to your browser and test
http://0.0.0.0:8000/terms
http://0.0.0.0:8000/definitions?term=person
```

### Test in local minikube

Run the following from your machine to test that the public Docker image works:

```
minikube start
## Apply the manifests:
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
minikube service python-api-service --url
# Go to your browser with that url and
Test with /terms
Test with /definitions?term=person

```

## Caveats
- The Python API endpoint uses HTTP in this local testing example; on a K8s cluster, we should enforce HTTPS
- The [`deifnitions.jsonl`](./definitions.jsonl) file is not persistent; it should ideally live in a permanent NoSQL database so that we can add records to it programatically
- You can build the docker image in minikube locally with the following:
```
eval $(minikube docker-env)
docker build -t python-api:latest .
```
You then need to change the image ID in [`k8s/deployment.yaml`](./k8s/deployment.yaml) to `image: docker.io/library/python-api:latest`