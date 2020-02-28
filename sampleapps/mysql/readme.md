### MYSQL

Deploy.yaml and deploy-harbor.yaml will create a deployment with 1 pod and 1 container based on the latest mysql image.
Svc.yaml will create a load-balancer service for mysql



#### Adding Harbor to K8s clusters
The mysql-harbor.yaml requires the regsecret docker-registry secret.  Create it like this:

kubectl create secret  docker-registry regsecret \
--docker-server=harbor.caas.pez.pivotal.io \
--docker-username=admin --docker-password=PASSWORD


#### Notes

* Some of the environment variables are secrets are in plain text in the deployment yaml.  It is better to put these into a secret or to dynamically pull the secrets from credhub
