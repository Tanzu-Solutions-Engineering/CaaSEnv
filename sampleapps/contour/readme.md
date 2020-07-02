## Install for tkg


### Install MetalLB
```
kubectl create ns metallb-system
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml -n metallb-system
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metalLB/metallb-config.yaml
```
### Install Cert-Manager
```
kubectl apply -f tkg-extensions/cert-manager/
```

### Install contour
```
kubectl apply -f tkg-extensions/contour/vsphere/
```
