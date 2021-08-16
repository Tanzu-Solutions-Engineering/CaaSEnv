### Install Velero 1.6.x
`velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.2.0 --bucket backup-harbor --secret-file ./credentials-velero --use-volume-snapshots=false --use-restic --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.caas.pez.pivotal.io:80
    `


### Add schedule
`kubectl apply -n velero -f ./velero-schedule.yaml`
