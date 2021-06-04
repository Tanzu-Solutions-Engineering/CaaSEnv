## Install TKG Extension Prereqs

```
kubectl apply -f extensions/kapp-controller-config.yaml
kubectl apply -f extensions/kapp-controller.yaml
kubectl apply -f cert-manager/
```

## FluentBit
```
kubectl apply -f extensions/logging/fluent-bit/namespace-role.yaml
kubectl create secret generic fluent-bit-data-values --from-file=values.yaml=fluent-bit-data-values.yaml -n tanzu-system-logging
kubectl apply -f extensions/logging/fluent-bit/fluent-bit-extension.yaml
```

### Update config
```
kubectl create secret generic fluent-bit-data-values --from-file=values.yaml=fluent-bit-data-values.yaml \
  -n tanzu-system-logging -o yaml --dry-run | kubectl replace -f-
```

### Remove FluentBit
```
kubectl delete -f extensions/logging/fluent-bit/fluent-bit-extension.yaml
kubectl delete app fluent-bit -n tanzu-system-logging
kubectl delete -f extensions/logging/fluent-bit/namespace-role.yaml
```

## Contour
```
kubectl apply -f extensions/ingress/contour/namespace-role.yaml
kubectl create secret generic contour-data-values --from-file=values.yaml=contour-data-values.yaml -n tanzu-system-ingress
kubectl apply -f extensions/ingress/contour/contour-extension.yaml
```

### Update config
```
kubectl create secret generic contour-data-values --from-file=values.yaml=contour-data-values.yaml \
  -n tanzu-system-ingress -o yaml --dry-run | kubectl replace -f-
```

### Validate
```
kubectl get app contour -n tanzu-system-ingress
```

### Remove
```
kubectl delete -f extensions/ingress/contour/contour-extension.yaml
kubectl delete app contour -n tanzu-system-ingress
kubectl delete -f extensions/ingress/contour/namespace-role.yaml
```

## Prometheus
```
kubectl apply -f extensions/monitoring/prometheus/namespace-role.yaml
kubectl create secret generic prometheus-data-values --from-file=values.yaml=prometheus-data-values.yaml \
  -n tanzu-system-monitoring
kubectl apply -f extensions/monitoring/prometheus/prometheus-extension.yaml
```

### Validate
```
kubectl get app prometheus -n tanzu-system-monitoring
```

### Update config
```
kubectl create secret generic prometheus-data-values --from-file=values.yaml=prometheus-data-values.yaml \
  -n tanzu-system-monitoring -o yaml --dry-run | kubectl replace -f-
```

### Remove
```
kubectl delete -f extensions/monitoring/prometheus/prometheus-extension.yaml
kubectl delete app prometheus -n tanzu-system-monitoring
kubectl delete -f extensions/monitoring/prometheus/namespace-role.yaml
```


## Grafana
May use contour, check contour-data-values.yaml
```
kubectl apply -f extensions/monitoring/grafana/namespace-role.yaml
kubectl create secret generic grafana-data-values --from-file=values.yaml=grafana-data-values.yaml \
  -n tanzu-system-monitoring
kubectl apply -f extensions/monitoring/grafana/grafana-extension.yaml
```

### Validate
```
kubectl get app grafana -n tanzu-system-monitoring
```

### Update config
```
kubectl create secret generic grafana-data-values --from-file=values.yaml=grafana-data-values.yaml \
  -n tanzu-system-monitoring -o yaml --dry-run | kubectl replace -f-
```


## Harbor
Requires contour
```
kubectl apply -f extensions/registry/harbor/namespace-role.yaml
kubectl create secret generic harbor-data-values --from-file=values.yaml=harbor-data-values.yaml \
  -n tanzu-system-registry
kubectl apply -f extensions/registry/harbor/harbor-extension.yaml
```

### Validate
```
kubectl get app harbor -n tanzu-system-registry
```
### Update config
```
kubectl create secret generic harbor-data-values --from-file=values.yaml=harbor-data-values.yaml \
  -n tanzu-system-registry -o yaml --dry-run | kubectl replace -f-
```

### Remove
```
kubectl delete -f extensions/registry/harbor/harbor-extension.yaml
kubectl delete app harbor -n tanzu-system-registry
kubectl delete -f extensions/registry/harbor/namespace-role.yaml
```

## External DNS
```
kubectl apply -f extensions/service-discovery/external-dns/namespace-role.yaml
kubectl create secret generic external-dns-data-values --from-file=values.yaml=external-dns-data-values.yaml \
  -n tanzu-system-service-discovery
kubectl apply -f extensions/service-discovery/external-dns/external-dns-extension.yaml
```

### Validate
```
kubectl get app external-dns -n tanzu-system-service-discovery
```

### Update config
```
kubectl create secret generic external-dns-data-values --from-file=values.yaml=external-dns-data-values.yaml \
  -n tanzu-system-service-discovery -o yaml --dry-run | kubectl replace -f-
```

### Remove
```
kubectl delete -f extensions/service-discovery/external-dns/external-dns-extension.yaml
kubectl delete app external-dns -n tanzu-system-service-discovery
kubectl delete -f extensions/service-discovery/external-dns/namespace-role.yaml
```
