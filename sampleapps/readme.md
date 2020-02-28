### Sample Apps

This folder contains subfolders of applications known to work in PKS in the Tanzu Commercial PA CaaS Lab environment.


#### Adding Harbor to K8s clusters

kubectl create secret  docker-registry regsecret \
--docker-server=harbor.caas.pez.pivotal.io \
--docker-username=admin --docker-password=PASSWORD

kubectl create secret docker-registry harbor \
--docker-server=harbor.pkswin.caas.pez.pivotal.io \
--docker-username=kube \
--docker-password=PASSWORD \
--docker-email=kube@caas.pez.pivotal.io

**Note - Windows K8s clusters do not inherit 'trusted certificates' from OpsManager**
