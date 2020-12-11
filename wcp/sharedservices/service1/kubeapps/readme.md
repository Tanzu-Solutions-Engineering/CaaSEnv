helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update 
kubectl create namespace kubeapps

helm install kubeapps --namespace kubeapps bitnami/kubeapps
