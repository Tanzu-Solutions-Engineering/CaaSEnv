## Install vSphere CSI Driver in TKGI 1.7 Cluster

### Prereqs
* Cluster has 'allow privileged' enabled
* TKGI 1.7+
* Nodes can reach vCenter Server
* vSphere 6.7U3+


### Steps

1. Update csi-vsphere.conf values
  * Update CLUSTER-ID with name of the cluster
  * Update user/password
  * Update FQDN of vcenter
2. Create secret from conf
```
kubectl create secret generic vsphere-config-secret \
 --from-file=csi-vsphere.conf \
 --namespace=kube-system  
```
3. Create RBAC for CSI Access
```
kubectl apply -f vsphere-csi-controller-rbac.yaml
```
4. Install CSI driver vis StatefulSet & DaemonSet
```
kubectl apply -f vsphere-csi-controller-ss.yaml
kubectl apply -f vsphere-csi-node-ds.yaml
```
5. Verify CNS/CSI
```
kubectl get pods --namespace=kube-system
```
Look for vsphere-csi pods running
