helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm repo update
kubectl create namespace concourse

helm install concourse -f concourse-values.yaml concourse/concourse -n concourse
