## Add PSP
kubectl apply -f ./allowrunasnonroot-clusterrole.yaml

## Add Metrics-Server

kubectl apply -f ./metrics-server.yaml

## Add prometheus

k create ns monitoring
helm install prometheus stable/prometheus  --namespace monitoring
kubectl expose -n monitoring deploy prometheus-server --name=prom-lb --port=80 --target-port=9090 --selector="app=prometheus,component=server" --type=LoadBalancer

## Add Velero
`velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.1.0 \
    --bucket backup-services1 \
    --secret-file ../credentials-velero \
    --use-volume-snapshots=false \
    --use-restic \
    --backup-location-config \
    region=minio,s3ForcePathStyle="true",s3Url=http://minio:9000
    `
## Contour
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

## Minio
kubectl create ns minio
kubectl apply -n minio -f ./minio-nfs.yaml

## Harbor

## Email
kubectl create ns mail
kubectl apply -n mail -f iredmail/

## Cert Manager
kubectl apply -f cert-manager/
