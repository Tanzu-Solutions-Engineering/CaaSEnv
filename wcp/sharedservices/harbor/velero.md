## Install Velero 1.6.x
### Dockerhub images
`velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.2.0 --bucket backup-harbor --secret-file ./credentials-velero --use-volume-snapshots=false --use-restic --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.caas.pez.pivotal.io:80
`
### Local Images
`velero install --provider aws --plugins harbor.caas.pez.pivotal.io/library/velero-plugin-for-aws:v1.2.0 --bucket backup-harbor --secret-file ./credentials-velero --use-volume-snapshots=false --use-restic --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.caas.pez.pivotal.io --image harbor.caas.pez.pivotal.io/library/velero:v1.6.3
`

### Add schedule
`kubectl apply -n velero -f ./velero-schedule.yaml`
