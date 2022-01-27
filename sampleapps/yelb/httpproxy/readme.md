

# Configure Contour HTTPProxy with TLS termination for yelb

# Prereqs
* Confirm cert-manager and contour are deployed to the cluster
* Confirm DNS record for yelb.demo.caas.pez.pivotal.io resolves to the LB IP of the envoy service

# Deployment Steps


## Deploy yelb
```
kubectl create ns yelb
kubectl apply -n yelb labharbor-yelb-lb.yml
```

##  Show how yelb uses an LB on port 80


# Create certificate
## Bootstrap CA & Root Certificate
```
kubectl apply -n yelb -f cabootstrap.yaml
```

## Create cert for yelb
```
kubectl create -n yelb -f ./certificate.yaml
```


## Create HTTPProxy
```
kubectl apply -n yelb -f httpproxy-yelb.yaml
```
