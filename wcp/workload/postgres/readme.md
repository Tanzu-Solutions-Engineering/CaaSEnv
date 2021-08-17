# Deploy Tanzu SQL with Postgres

## Prep Cluster
```
kubectl apply -f ./allowrunasnonroot-clusterrole.yaml
```


## Install CertManager:
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.4.2 --set installCRDs=true
```


## Download postgres-for-kubernetes-v*.tar.gz
  Extract it
  change to postgres-for-kubernetes-v* folder

## Copy images to local repo
  ```
  docker load -i ./images/postgres-instance
  docker load -i ./images/postgres-operator
  PROJECT=tanzu-sql
  REGISTRY="harbor.caas.pez.pivotal.io/${PROJECT}"

  INSTANCE_IMAGE_NAME="${REGISTRY}/postgres-instance:$(cat ./images/postgres-instance-tag)"
  docker tag $(cat ./images/postgres-instance-id) ${INSTANCE_IMAGE_NAME}
  docker push ${INSTANCE_IMAGE_NAME}

  OPERATOR_IMAGE_NAME="${REGISTRY}/postgres-operator:$(cat ./images/postgres-operator-tag)"
  docker tag $(cat ./images/postgres-operator-id) ${OPERATOR_IMAGE_NAME}
  docker push ${OPERATOR_IMAGE_NAME}
```

## Create Namespace for Operator, harbor secret and CA
```
kubectl create ns postgres
kubectl --namespace postgres create secret docker-registry harbor --docker-server=https://harbor.caas.pez.pivotal.io --docker-username=admin@caas.pez.pivotal.io --docker-password=<PASSWORD>
```

## get Chart:
```
export HELM_EXPERIMENTAL_OCI=1
helm registry login registry.pivotal.io --username=<USERNAME> --password=<PASSWORD>
helm chart pull registry.pivotal.io/tanzu-sql-postgres/postgres-operator-chart:v1.2.0
helm chart export registry.pivotal.io/tanzu-sql-postgres/postgres-operator-chart:v1.2.0  --destination=./
```

### Create operator-values-overrides.yaml
  copy ./postgres-operator/values.yaml to ./operator-values-overrides.yaml
  modify the registry, tags, etc.
  Set certManagerClusterIssuerName to 'selfsigned-issuer' (it was created by cabootstrap)


## Deploy operator via helm
```
helm install postgres-operator -n postgres -f ./operator-values-overrides.yaml postgres-operator/
```

### Confirm the pod is running:
```
kubectl get all -n postgres
```
## Create Namespace for postgres databases:
```
kubectl create ns postgres-databases
```


## Create an example pg database
    kubectl apply -n postgres-databases -f pg-instance-example.yaml

### Run psql inside the pg instance
    kubectl exec -it pg-instance-example-0 -- bash -c "psql"


## Retrieve the credentials in order to connect to the instance from outside
    dbip=$(kubectl get svc -n postgres-databases pg-instance-example -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    dbname=$(kubectl get secrets pg-instance-example-db-secret -n postgres-databases -o jsonpath='{.data.dbname}' | base64 -D)
    username=$(kubectl get secrets pg-instance-example-db-secret -n postgres-databases -o jsonpath='{.data.username}' | base64 -D)
    password=$(kubectl get secrets pg-instance-example-db-secret -n postgres-databases -o jsonpath='{.data.password}' | base64 -D)
    echo "Connect to $dbname on $dbip using $username | $password"




## Deploy pgAdmin
    helm repo add runix https://helm.runix.net/
    helm install pgadmin4 runix/pgadmin4 -n postgres \
    --set service.type=LoadBalancer,persistentVolume.storageClass=tanzu,env.email=pgadmin@pgadmin.org,env.password=pgadmin \
    --set image.registry=harbor.caas.pez.pivotal.io,image.repository=library/pgadmin4,image.tag=5.4


### Using pgadmin

* Login with pgadmin@pgadmin.com | pgadmin
* Add a new Database using the name, IP and credentials from the script above
