### RabbitMQ for Kubernetes

#### Deploy
* Create Harbor regsecret

  `kubectl create secret  docker-registry regsecret \
  -n pivotal-rabbitmq-system \
  --docker-server=harbor.caas.pez.pivotal.io \
  --docker-username=admin --docker-password=PASSWORD`
* Create pivotal-rabbitmq-systerm namespace:

  `kubectl apply -f deploy/namespace.yaml`
* Create broker, services, etc:  

  `kubectl apply -n pivotal-rabbitmq-system -f deploy/.`



#### Post-deploy
* Confirm Rabbit CRD exists

  `kubectl get customresourcedefinitions.apiextensions.k8s.io`


#### Manage
* Create Namespace for Rabbit MQ instances: `kubectl create ns rabbit-instances`
* Create Instance and PDB: `kubectl -n rabbit-instances apply -f manage/definition.yaml`
* Find admin account username:
  `kubectl -n rabbit-instances get secret rabbitmqcluster-sample-rabbitmq-admin -o jsonpath="{.data.rabbitmq-username}" | base64 --decode`
* Find admin account password:
  `kubectl -n rabbit-instances get secret rabbitmqcluster-sample-rabbitmq-admin -o jsonpath="{.data.rabbitmq-password}" | base64 --decode`
