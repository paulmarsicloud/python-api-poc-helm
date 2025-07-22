# python-api-poc-helm

This is a poc repo that builds extends [python-api-poc](https://github.com/paulmarsicloud/python-api-poc) to be consumed in Helm. It includes prometheus and grafana for monitoring out of the box.

## Pre-requisites

To run this service locally in minikube, you'll need:

- **Minikube** v1.35.0
- **Helm** v3.17.3

## CI / CD Workflow

Every pull request:

- Ensures the Docker image builds successfully
- Runs all tests (`pytest`)

On merge to `main`:

- Builds and pushes the Docker image to [GitHub Packages](https://github.com/users/paulmarsicloud/packages/container/package/python-api-poc-helm)

## Local Testing on Minikube

Run the following to test on minikube:

```
minikube start

cd charts/python-api
helm dependency update
cd ../..
helm install python-poc-api-helm charts/python-api --create-namespace -n python-api

minikube service python-poc-api-helm -n python-api --url

# Go to your browser with that url and
Test with /terms
Test with /definitions?term=person

minikube service python-poc-api-helm-grafana -n python-api --url
# Go to your browser and test with admin/admin

minikube service python-poc-api-helm-prometheus-server  -n python-api --url
# Go to your browser and test

```
