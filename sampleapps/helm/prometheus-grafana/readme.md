# Install chart

k create ns monitoring
helm install prometheus-operator stable/prometheus-operator  --namespace monitoring --set grafana.adminPassword="admin"

#Expose Service (LoadBalancer)

kubectl expose deploy prometheus-operator-grafana --name=prometheus-operator-grafana-lb --port=80 --target-port=3000 -n monitoring --selector=app.kubernetes.io/name=grafana --type=LoadBalancer

#Expose Service (NodePort)
kubectl expose deploy prometheus-operator-grafana --name=prometheus-operator-grafana-np --port=80 --target-port=3000 -n monitoring --selector=app.kubernetes.io/name=grafana --type=NodePort
