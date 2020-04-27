## Steps ##

* brew install helm
* brew --version (check for 3.1+)
*


## Prometheus

1. helm install prometheus-operator stable/prometheus-operator --namespace monitoring
1. kubectl expose deploy prometheus-operator-operator --port=9090 --target-port=9090 --name=prometheus --selector=app=prometheus -n monitoring --type=LoadBalancer
1. kubectl expose deploy prometheus-operator-grafana --port=3000 --target-port=3000 --name=grafana --selector=app=grafana -n monitoring --type=LoadBalancer

   admin | prom-operator
1. kubectl expose svc prometheus-operator-alertmanager --port=9093 --target-port=9093 --name=alertmanager -n monitoring --type=LoadBalancer


## Troubleshooting

1. kubectl create serviceaccount --namespace kube-system tiller
1. kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
1. kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
