### Yelb


* yelb-lb.yaml : deploys with a LoadBalancer Service
* yelb-harbor-lb.yaml : deploys harbor using images from local repo
* yelb-pv.yaml: deploys yelb with a PV for postgres data


* yelb-to-harbor.sh : pull images from dockerhub, push to harbor

* yelb-harbor-lab.yaml : deploy yelb using images from Harbor
** Create a docker-registry secret named harbor first

kubectl create secret docker-registry harbor --docker-username=admin --dockeer-password=pivotal123



![alt text](https://raw.githubusercontent.com/mreferre/yelb/master/images/yelb-architecture.png "yelb components")

* See https://github.com/mreferre/yelb
