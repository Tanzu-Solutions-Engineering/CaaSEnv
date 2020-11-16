## Add PSP
kubectl apply -f ./allowrunasnonroot-clusterrole.yaml

## Add Metrics-Server
kubectl apply -f ./metrics-server.yaml

## Add kube-state-metrocs
kubectl apply -f kube-state-metrics.yaml

## Add prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

kubectl create ns monitoring
helm install prometheus prometheus-community/prometheus  --namespace monitoring --set server.persistentVolume.storageClass=tanzu,alertmanager.persistentVolume.storageClass=tanzu

### Expose Service (NodePort)
kubectl expose -n monitoring deploy prometheus-server --name=prom-np --port=80 --target-port=9090 --selector="app=prometheus,component=server" --type=NodePort

## Add Kube-State-Metrics
kubectl apply -f kube-state-metrics.yaml

## Add Telegraf, InfluxDb, grafana
kubectl apply -n monitoring -f grafana/

## Add Velero
`velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.1.0 \
    --bucket backup-monitoring \
    --secret-file ../credentials-velero \
    --use-volume-snapshots=false \
    --use-restic \
    --backup-location-config \
    region=minio,s3ForcePathStyle="true",s3Url=http://minio:9000
    `


## dashboards
* 8165 - vSphere Hosts
* 8159 - vSphere Overview
* 8162 - vSphere Datastore
* 10430 - vSAN Overview
* 10431 - vSAN Host
* 7249 - Kubernetes Cluster
* 1860 - Node Exporter Full
* 315 - K8s Cluster monitoring
