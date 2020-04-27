
## Wavefront

helm repo add wavefront https://wavefronthq.github.io/helm/
helm repo update
helm install wavefront/wavefront --name wavefront \
--set wavefront.url=https://YOUR_CLUSTER.wavefront.com --set wavefront.token=YOUR_API_TOKEN \
--set clusterName=<YOUR_CLUSTER_NAME> --namespace wavefront
