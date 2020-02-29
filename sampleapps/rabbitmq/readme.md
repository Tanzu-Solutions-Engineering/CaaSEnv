### RabbitMQ for Kubernetes

#### Deploy
* Create Harbor regsecret
* Apply namespace.yaml
* Apply -n pivotal-rabbitmq-system -f .


#### Adding Harbor to K8s clusters
This requires the regsecret docker-registry secret.  Create it like this:

kubectl create secret  docker-registry regsecret \
-n pivotal-rabbitmq-system \
--docker-server=harbor.caas.pez.pivotal.io \
--docker-username=admin --docker-password=PASSWORD

#### Post-deploy
* Confirm Rabbit CRD exists
kubectl get customresourcedefinitions.apiextensions.k8s.io




#### Notes

* Some of the environment variables are secrets are in plain text in the deployment yaml.  It is better to put these into a secret or to dynamically pull the secrets from credhub
