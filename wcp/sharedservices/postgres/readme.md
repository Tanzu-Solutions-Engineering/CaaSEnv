# Deploy Tanzu SQL

## Add prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

kubectl create ns monitoring
helm install prometheus prometheus-community/prometheus  --namespace monitoring \
--set server.service.type=LoadBalancer


## Clone this repo
* so you have the operator folder and yaml files

## Create Namespace and Harbor Secret
    kubectl create ns postgres
    kubectl create secret docker-registry harbor -n postgres --docker-server=harbor.ragazzilab.com --docker-username=harboradmin@ragazzilab.com --docker-email=harboradmin --docker-password=VMware1!

## Update helm, install cert-manager
    kubectl apply -f cert-manager/


## Deploy Postgres-Operator from local chart

    helm install -v postgres-operator -n postgres operator/


## Create an example pg database
    kubectl apply -n postgres -f pg-instance-example.yaml

### Run psql inside the pg instance
    kubectl exec -it pg-instance-example-0 -- bash -c "psql"


## Retrieve the credentials in order to connect to the instance from outside
    dbip=$(kubectl get svc -n postgres pg-instance-example -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    dbname=$(kubectl get secrets pg-instance-example-db-secret -n postgres -o jsonpath='{.data.dbname}' | base64 -D)
    username=$(kubectl get secrets pg-instance-example-db-secret -n postgres -o jsonpath='{.data.username}' | base64 -D)
    password=$(kubectl get secrets pg-instance-example-db-secret -n postgres -o jsonpath='{.data.password}' | base64 -D)
    echo "Connect to $dbname on $dbip using $username | $password"


## Retrieve the credentials in order to connect to the instance from outside (Concourse)
    dbip=$(kubectl get svc -n postgres pg-concourse -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    dbname=$(kubectl get secrets pg-concourse-db-secret -n postgres -o jsonpath='{.data.dbname}' | base64 -D)
    username=$(kubectl get secrets pg-concourse-db-secret -n postgres -o jsonpath='{.data.username}' | base64 -D)
    password=$(kubectl get secrets pg-concourse-db-secret -n postgres -o jsonpath='{.data.password}' | base64 -D)
    echo "Connect to $dbname on $dbip using $username | $password"


## Deploy pgAdmin
    helm repo add runix https://helm.runix.net/
    helm install pgadmin4 runix/pgadmin4 -n postgres \
    --set service.type=LoadBalancer,persistentVolume.storageClass=tanzu,env.email=pgadmin@pgadmin.org,env.password=pgadmin


### Using pgadmin

* Login with pgadmin@pgadmin.com | pgadmin
* Add a new Database using the name, IP and credentials from the script above
