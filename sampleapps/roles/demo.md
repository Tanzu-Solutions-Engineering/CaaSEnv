
Github, pipelines and config
pipeline use of credhub

Concourse
Retrieval Pipeline
  Schedule
Deployment pipeline
  Objectives:  repeatable, atomic, integration with AD
  Trigger updates
Update Pipeline
  Schedule

Active Directory
Connect to ADC
Review Groups
Create users

Login to PKS as AD Account
pks get-credentials to get to cluster as admin

Show role & rolebinding
Create role and rolebinding


pks get-kubeconfig tkgi-ws1 -u dev1@caas.pez.pivotal.io -p Pivotal123 -a api.tkgi.caas.pez.pivotal.io -k
to set kubeconfig for user without pks access

Deploy yelb as dev1
