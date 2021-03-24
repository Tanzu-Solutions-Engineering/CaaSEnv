## Prepare cluster
```
kubectl apply -f allowrunasnonroot-cluster.yaml
kubectl apply -f metrics-server.yaml
```



## pull and push images and chart
docker pull registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-instance:0.2.0
export HELM_EXPERIMENTAL_OCI=1
helm chart pull registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator-chart:0.2.0
docker pull registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator:0.2.0
docker tag registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-instance:0.2.0 harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-instance:0.2.0
docker tag registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator:0.2.0 harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-operator:0.2.0
docker push harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-instance:0.2.0
docker push harbor.caas.pez.pivotal.io/tanzu-sql/tanzu-mysql-operator:0.2.0

## Export Chart
helm chart export registry.pivotal.io/tanzu-mysql-for-kubernetes/tanzu-mysql-operator-chart:0.2.0
 * Copy values.yaml to values-override.yaml
 * edit values-override.yaml with correct secret and registry

## Create Operator Deployment

kubectl create namespace tanzu-mysql
kubectl --namespace tanzu-mysql create secret docker-registry harbor --docker-server=https://harbor.caas.pez.pivotal.io --docker-username=harboradmin@caas.pez.pivotal.io --docker-password=<PASSWORD>
helm install --namespace tanzu-mysql --values=./tanzu-mysql-operator/values-override.yaml tanzu-mysql-operator ./tanzu-mysql-operator/



## Create instance

kubectl create ns mysql-instances
kubectl --namespace mysql-instances create secret docker-registry harbor --docker-server=https://harbor.caas.pez.pivotal.io --docker-username=harboradmin@caas.pez.pivotal.io --docker-password=<PASSWORD>

kubectl apply -n mysql-instances -f ./mysqlexample.yaml


## Get IP and credentials

kubectl get secret -n mysql-instances tanzumysql-sample-credentials -o jsonpath='{.data.rootPassword}' | base64 -D




## Kubeapps
```
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set frontend.service.type=LoadBalancer
```

Use Kubeapps to deploy phpMyAdmin, connect it to the mysql instance
