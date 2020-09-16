
##  TKG
```
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.1.0 \
    --bucket backup-dex \
    --secret-file ./credentials-velero \
    --use-volume-snapshots=true \
    --use-restic \
    --backup-location-config \
    region=minio,s3ForcePathStyle="true",s3Url=http://192.168.100.176:9000
```
## Secret
Need to create a secret named vsphere-config-secret from the csi-vsphere.conf in the kube-system namespace
```
kubectl create secret generic vsphere-config-secret -n kube-system --from-file=./csi-vsphere.conf
```


## Add Plugin and snapshot location
```velero plugin add vsphereveleroplugin/velero-plugin-for-vsphere:1.0.0

velero snapshot-location create vsl-vsphere --provider velero.io/vsphere
```
## Test Backup
velero backup create demo-app-backup --include-namespaces=demo-app --snapshot-volumes --volume-snapshot-locations vsl-vsphere

velero backup create mc-backup --include-namespaces=mc --snapshot-volumes --volume-snapshot-locations vsl-vsphere
