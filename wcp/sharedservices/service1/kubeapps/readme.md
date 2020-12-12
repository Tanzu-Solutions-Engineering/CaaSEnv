helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace kubeapps

helm install kubeapps --namespace kubeapps bitnami/kubeapps --set ingress.enabled=true,ingress.hostname="kubeapps.caas.pez.pivotal.io"


Configure a service account and get its auth token

`
kubectl create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator
kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' | grep kubeapps-operator-token) -o jsonpath='{.data.token}' -o go-template='{{.data.token | base64decode}}' && echo
`

Point your browser at the KubeApps Service IP and paste the token to login
