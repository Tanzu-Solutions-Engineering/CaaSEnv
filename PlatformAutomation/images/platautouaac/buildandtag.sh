#!/bin/bash
docker build -t platautouaac:4.3.0 .

docker tag platautouaac:4.3.0 harbor-ctrl.caas.pez.pivotal.io/platauto/platautouaac:4.3.0
docker push harbor-ctrl.caas.pez.pivotal.io/platauto/platautouaac:4.3.0
