#!/usr/bin/env bash

kubectl apply -f 00-fluent-bit-namespace.yaml
kubectl apply -f 01-fluent-bit-service-account.yaml
kubectl apply -f 02-fluent-bit-role.yaml
kubectl apply -f 03-fluent-bit-role-binding.yaml
kubectl apply -f output/http/04-fluent-bit-configmap.yaml
kubectl apply -f output/http/05-fluent-bit-ds.yaml
