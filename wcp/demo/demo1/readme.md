## Add Velero
`velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.1.0 \
--bucket backup-demo1 --secret-file credentials-velero \
--use-volume-snapshots=false --use-restic \
--backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.caas.pez.pivotal.io:9000
    `

velero schedule create cluster-daily --schedule="@every 24h" --ttl 48h0m0s


## Harbor Secret
kubectl create secret docker-registry -n yelb harbor --docker-server=harbor.caas.pez.pivotal.io --docker-username=harborread@caas.pez.pivotal.io --docker-password=<password>
