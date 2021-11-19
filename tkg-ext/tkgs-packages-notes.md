

# Set up Prereqs

## Apply kapp-controller
```
kubectl apply -f kapp-controller.yaml
```

## Check that pods are running
```
kubectl get po -n tkg-system
```

## Create namespace for fluent-bit & ExternalDNS
```
kubectl create ns tanzu-system-logging
kubectl create ns tanzu-system-service-discovery
kubectl create ns cert-manager
```


## Configure packages for tanzu CLI
```
tanzu package repository add std140 --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0 --namespace tanzu-system-logging
tanzu package repository add std140 --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0 --namespace tanzu-system-service-discovery
tanzu package repository add std140 --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0 --namespace cert-manager
tanzu package repository list -A
```

## Verify that the packages are listed after repo reconciles
```
tanzu package available list -A
```


# FluentBit
## Find the available version:
```
tanzu package available list fluent-bit.tanzu.vmware.com --namespace tanzu-system-logging
```

## install FluentBit to the targeted NS

```
tanzu package install fluent-bit \
  --package-name fluent-bit.tanzu.vmware.com \
  --namespace tanzu-system-logging \
  --version 1.7.5+vmware.1-tkg.1 \
  --values-file fluent-bit-data-values.yaml
```
# ExternalDNS
## Find the available version:
```
tanzu package available list external-dns.tanzu.vmware.com --namespace tanzu-system-service-discovery
```

## install ExternalDNS to the targeted NS
```
tanzu package install external-dns \
  --package-name external-dns.tanzu.vmware.com \
  --version 0.8.0+vmware.1-tkg.1 \
  --values-file external-dns-data-values.yaml \
  --namespace tanzu-system-service-discovery
```

#Cert-Manager

## install cert-manager
```
tanzu package install cert-manager \
  --package-name cert-manager.tanzu.vmware.com \
  --namespace cert-manager \
  --version 1.1.0+vmware.1-tkg.2
```

# See packages:
```
tanzu package installed list -A
```



# Remove
```
tanzu package installed delete fluent-bit --namespace tanzu-system-logging
``
