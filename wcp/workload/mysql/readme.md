

## Prepare cluster
```
kubectl apply -f ./allowrunasnonroot-clusterrole.yaml
kubectl apply -f ./metrics-server.yml
```

## pull and push images and chart
### 1.0.0
```
docker pull registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-instance:1.0.0
export HELM_EXPERIMENTAL_OCI=1
helm chart pull registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator-chart:1.0.0
docker pull registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator:1.0.0
docker tag registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-instance:1.0.0 harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-instance:1.0.0
docker tag registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator:1.0.0 harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-operator:1.0.0
docker push harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-instance:1.0.0
docker push harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-operator:1.0.0
```

## Export Chart
```
helm chart export registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator-chart:1.0.0
```
 * Copy values.yaml to values-override.yaml
 * edit values-override.yaml with correct secret and registry

## Create Operator Deployment
```
kubectl create namespace tanzu-mysql
kubectl --namespace tanzu-mysql create secret docker-registry harbor --docker-server=https://harbor.caas.pez.pivotal.io --docker-username=admin@caas.pez.pivotal.io --docker-password=<PASSWORD>
helm install --namespace tanzu-mysql --values=./tanzu-sql-with-mysql-operator/values-override.yaml tanzu-mysql-operator ./tanzu-sql-with-mysql-operator/
```


## Create instance
### Create Namespace
```
kubectl create ns mysql-instances
```
### Create TLS Secret with  CertManager:
```
  kubectl create namespace cert-manager
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.4.1 --set installCRDs=true

  kubectl --namespace mysql-instances apply -f certmanager/cabootstrap.yaml
  kubectl --namespace mysql-instances apply -f certmanager/certificate.yaml
```


### Create Harbor Secret
```
kubectl --namespace mysql-instances create secret docker-registry harbor --docker-server=https://harbor.caas.pez.pivotal.io --docker-username=harboradmin@caas.pez.pivotal.io --docker-password=<PASSWORD>
```

### Create Instance
```
kubectl apply -n mysql-instances -f ./mysqlexample.yaml
```

## Get IP and credentials

kubectl get secret -n mysql-instances mysql-tls-credentials -o jsonpath='{.data.rootPassword}' | base64 -D

### Connecting without SSL
You may have to use phpMyAdmin to set the require_secure_transport to OFF is you do not import an SSL certificate

##  Login via kubectl as root to create an additional user:
```
kubectl -n mysql-instances exec --stdin --tty pod/mysql-tls-0 -c mysql -- /bin/bash
```
then run
```
  mysql -uroot -p$<root password>
```
Once in the mysql session, run this to create a new user:
```  
  CREATE USER 'admin'@'%' IDENTIFIED BY 'password';
  GRANT ALL PRIVILEGES ON * . * TO 'admin'@'%';
  FLUSH PRIVILEGES;
```

## Kubeapps
```
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set frontend.service.type=LoadBalancer
```

Use Kubeapps to deploy phpMyAdmin, connect it to the mysql instance using the user credentials created above

## Backup
Add backuplocation to instance in the same namespace as the mysql instances
```
kubectl apply -n mysql-instances -f ./backuplocation.yaml
```

### On-demand backup
```
kubectl apply -n mysql-instances -f ./backup-ondemand.yaml
```

### Backup Schedule
Uncomment the section in backuplocation


## Remove Tanzu SQL with MySQL
```
helm uninstall --namespace tanzu-mysql  tanzu-mysql-operator
```


## Update config after deploy
```
helm upgrade --namespace tanzu-mysql --values=./tanzu-sql-with-mysql-operator/values-override.yaml tanzu-mysql-operator ./tanzu-sql-with-mysql-operator/
```
