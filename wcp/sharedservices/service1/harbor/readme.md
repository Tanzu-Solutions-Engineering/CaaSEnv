# Harbor

## Add helm repo
helm repo add harbor https://helm.goharbor.io

## Create tls secret:
kubectl create secret generic harbor-tls --from-file=tls.crt --from-file=tls.key -n harbor


## Deploy
helm install harbor harbor/harbor --namespace harbor \
--set expose.type=loadBalancer,expose.tls.enabled=true,expose.tls.auto.commonName=harbor.caas.pez.pivotal.io,\
externalURL=harbor.caas.pez.pivotal.io,harborAdminPassword=Pivotal123,\
persistence.persistentVolumeClaim.registry.size=20Gi,\
persistence.persistentVolumeClaim.registry.storageClass=vsan,\
persistence.persistentVolumeClaim.chartmuseum.storageClass=vsan,\
persistence.persistentVolumeClaim.jobservice.storageClass=vsan,\
persistence.persistentVolumeClaim.database.storageClass=vsan,\
persistence.persistentVolumeClaim.redis.storageClass=vsan,\
persistence.persistentVolumeClaim.trivy.storageClass=vsan,\
redis.podAnnotations."backup\.velero\.io/backup-volumes"=data,\
registry.podAnnotations."backup\.velero\.io/backup-volumes"=registry-data,\
trivy.podAnnotations."backup\.velero\.io/backup-volumes"=data,\
database.podAnnotations."backup\.velero\.io/backup-volumes"=database-data,\
chartmuseum.podAnnotations."backup\.velero\.io/backup-volumes"=chartmuseum-data,\
jobservice.podAnnotations."backup\.velero\.io/backup-volumes"=job-logs



## Fix Harbor after velero restore

1. Edit the database statefulSet: `kubectl edit StatefulSet harbor-harbor-database -n harbor`
Replace the command in the “change-permission-of-directory” initContainer from chown -R 999:999 /var/lib/postgresql/data to chmod -R 0700 /var/lib/postgresql/data
2. Save changes and bounce the database pod by running `kubectl delete po -n harbor harbor-harbor-database-0`
3. Bounce the remaining pods that are in CrashLoopBackup (because they’re trying to connect to the database)