### Pipelines

This folder contains a number of concourse pipelines in yaml format

To add/update the pipeline in concourse, use fly:

* fly -t caas login -c https://concourse.caas.pez.pivotal.io -u *username* -p *password* -n *teamname* -k
* fly -t caas sp -p $PL -c retrieve-pks-ondemand.yml -l *./params-file.yml*

#### retrieve-pks-ondemand

Retrieves binaries from PivNet, saves them to local S3.

To avoid downloading 30GB daily, each download task must be triggered manually

Uses version information found in download-product-configs to filter versions

* Harbor & required stemcell
* Ops manager
* PKS & required stemcell
* bbr
* Platform Automation tasks and image
* Pivotal internal-only Windows Stemcell


#### retrieve-pas-ondemand

Retrieves binaries from PivNet, saves them to local S3.

To avoid downloading 30GB daily, each download task must be triggered manually

Uses version information found in download-product-configs to filter versions

* Ops manager
* PAS & required stemcell
* PAS Windows
* MySQL
* Healthwatch
* NSX-T NCP
* bbr
* Platform Automation tasks and image
* Pivotal internal-only Windows Stemcell
