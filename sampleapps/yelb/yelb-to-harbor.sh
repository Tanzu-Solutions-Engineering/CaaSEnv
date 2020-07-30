#!/usr/bin/env bash

docker pull mreferre/yelb-ui:0.5
docker pull redis:4.0.2
docker pull mreferre/yelb-db:0.5
docker pull mreferre/yelb-appserver:0.5

docker tag mreferre/yelb-ui:0.5 harbor-ctrl.caas.pez.pivotal.io/library/yelb-ui:0.5
docker tag redis:4.0.2  harbor-ctrl.caas.pez.pivotal.io/library/redis:4.0.2
docker tag mreferre/yelb-db:0.5  harbor-ctrl.caas.pez.pivotal.io/library/yelb-db:0.5
docker tag mreferre/yelb-appserver:0.5  harbor-ctrl.caas.pez.pivotal.io/library/yelb-appservr:0.5

docker push harbor-ctrl.caas.pez.pivotal.io/library/yelb-ui:0.5
docker push harbor-ctrl.caas.pez.pivotal.io/library/redis:4.0.2
docker push harbor-ctrl.caas.pez.pivotal.io/library/yelb-db:0.5
docker push harbor-ctrl.caas.pez.pivotal.io/library/yelb-appservr:0.5
