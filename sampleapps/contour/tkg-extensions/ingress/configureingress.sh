#!/usr/bin/env bash

kubectl apply -f ../cert-manager/
kubectl apply -f contour/vsphere/

kubectl apply -f contour/examples/common/
kubectl apply -f contour/examples/http-ingress/
kubectl apply -f contour/examples/https-ingress/

kubectl get service envoy -n tanzu-system-ingress -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}'
