# Deploy Tanzu SQL

## Clone this repo
* so you have the operator folder and yaml files

## Update helm, install cert-manager
    kubectl create namespace cert-manager
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager --namespace cert-manager  --version v1.0.2 --set installCRDs=true


## Deploy Postgres-Operator from local chart
    helm install postgres-operator -n postgres operator/


## Create an example pg database
    kubectl apply -n postgres -f pg-instance-example.yaml

### Run psql inside the pg instance
    kubectl exec -it pg-instance-example-0 -- bash -c "psql"


## Retrieve the credentials in ordert to connect to the instance from outside
    dbip=$(kubectl get svc -n postgres pg-instance-example -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    dbname=$(kubectl get secrets pg-instance-example-db-secret -n postgres -o jsonpath='{.data.dbname}' | base64 -D)
    username=$(kubectl get secrets pg-instance-example-db-secret -n postgres -o jsonpath='{.data.username}' | base64 -D)
    password=$(kubectl get secrets pg-instance-example-db-secret -n postgres -o jsonpath='{.data.password}' | base64 -D)
    echo "Connect to $dbname on $dbip using $username | $password"



## Deploy pgAdmin
    helm repo add runix https://helm.runix.net/
    helm install pgadmin4 runix/pgadmin4 -n postgres --set service.type=LoadBalancer,persistentVolume.storageClass=tanzu,env.email=pgadmin@pgadmin.org,env.password=pgadmin


### Using pgadmin

* Login with pgadmin@pgadmin.com | pgadmin
* Add a new Database using the name, IP and credentials from the script above
