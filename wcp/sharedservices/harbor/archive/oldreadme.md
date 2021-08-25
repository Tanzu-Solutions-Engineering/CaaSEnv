# Harbor

## Add helm repo
    helm repo add harbor https://helm.goharbor.io

## Create tls secret:
    kubectl create secret generic harbor-tls --from-file=tls.crt --from-file=private.key -n harbor


## Deploy - with certificate
    helm install harbor harbor/harbor --namespace harbor --set expose.type=loadBalancer,expose.tls.enabled=true,expose.tls.auto.commonName=harbor.caas.pez.pivotal.io,expose.tls.secret.secretName=harbor-tls,expose.tls.certSource=secret,externalURL=harbor.caas.pez.pivotal.io,harborAdminPassword=Pivotal123,persistence.persistentVolumeClaim.registry.size=20Gi,persistence.persistentVolumeClaim.registry.storageClass=tanzu,persistence.persistentVolumeClaim.chartmuseum.storageClass=tanzu,persistence.persistentVolumeClaim.jobservice.storageClass=tanzu,persistence.persistentVolumeClaim.database.storageClass=tanzu,persistence.persistentVolumeClaim.redis.storageClass=tanzu,persistence.persistentVolumeClaim.trivy.storageClass=tanzu,redis.podAnnotations."backup\.velero\.io/backup-volumes"=data,registry.podAnnotations."backup\.velero\.io/backup-volumes"=registry-data,trivy.podAnnotations."backup\.velero\.io/backup-volumes"=data,database.podAnnotations."backup\.velero\.io/backup-volumes"=database-data,chartmuseum.podAnnotations."backup\.velero\.io/backup-volumes"=chartmuseum-data,jobservice.podAnnotations."backup\.velero\.io/backup-volumes"=job-logs,expose.LoadBalancer.IP=10.193.39.40

## Deploy - generate certificate
    helm install harbor harbor/harbor --namespace harbor --set expose.type=loadBalancer,expose.tls.enabled=true,expose.tls.auto.commonName=harbor.caas.pez.pivotal.io,externalURL=harbor.caas.pez.pivotal.io,harborAdminPassword=Pivotal123,persistence.persistentVolumeClaim.registry.size=20Gi,persistence.persistentVolumeClaim.registry.storageClass=tanzu,persistence.persistentVolumeClaim.chartmuseum.storageClass=tanzu,persistence.persistentVolumeClaim.jobservice.storageClass=tanzu,persistence.persistentVolumeClaim.database.storageClass=tanzu,persistence.persistentVolumeClaim.redis.storageClass=tanzu,persistence.persistentVolumeClaim.trivy.storageClass=tanzu,redis.podAnnotations."backup\.velero\.io/backup-volumes"=data,registry.podAnnotations."backup\.velero\.io/backup-volumes"=registry-data,trivy.podAnnotations."backup\.velero\.io/backup-volumes"=data,database.podAnnotations."backup\.velero\.io/backup-volumes"=database-data,chartmuseum.podAnnotations."backup\.velero\.io/backup-volumes"=chartmuseum-data,jobservice.podAnnotations."backup\.velero\.io/backup-volumes"=job-logs,expose.LoadBalancer.IP=10.193.39.40


## Fix Harbor after velero restore

1. Edit the database statefulSet: `kubectl edit StatefulSet harbor-harbor-database -n harbor`
Replace the command in the “change-permission-of-directory” initContainer from chown -R 999:999 /var/lib/postgresql/data to chmod -R 0700 /var/lib/postgresql/data
2. Save changes and bounce the database pod by running `kubectl delete po -n harbor harbor-harbor-database-0`
3. Bounce the remaining pods that are in CrashLoopBackup (because they’re trying to connect to the database)


# Harbor from TKG Extensions
Ref: https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.2/vmware-tanzu-kubernetes-grid-12/GUID-extensions-harbor-registry.html

## Prereq
 * Download and extract the tkg package including Carvel tools to your path
 * Download and extract the tkg Extensions Manifest


## Steps
  1. Apply `/extensions/tmc-extension-manager.yaml` from TKG Extensions Manifest to target k8s cluster
  2. Apply `/extensions/kapp-controller.yaml` from TKG Extensions Manifest to target k8s cluster
  3. Apply `/cert-manager/` from TKG Extensions Manifest to target k8s cluster
  4. Deploy Contour to target cluster
      * Apply `ingress/contour/namespace-role.yaml`
