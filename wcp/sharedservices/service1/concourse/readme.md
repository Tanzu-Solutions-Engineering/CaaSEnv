
## Harbor Secret
kubectl create secret docker-registry -n concourse harbor --docker-server=harbor.caas.pez.pivotal.io --docker-username=harborread@caas.pez.pivotal.io --docker-password=<password>


helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm repo update
kubectl create namespace concourse

helm install concourse -f concourse-values.yaml concourse/concourse -n concourse
