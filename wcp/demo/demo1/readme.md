## Add Velero
`velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.1.0 \ 
--bucket backup-demo1 --secret-file credentials-velero \
--use-volume-snapshots=false --use-restic \
--backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.caas.pez.pivotal.io:9000
    `
