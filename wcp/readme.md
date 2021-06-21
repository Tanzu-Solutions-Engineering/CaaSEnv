# Config repo for vSphere with Tanzu

## Namespaces and Clusters

- **sharedservices** - Clusters hosting common Services
 - harbor2 - Harbor for TKGS
 - mysql - Tanzu SQL with mySQL
 - postgres - Tanzu SQL with postgres
- **test-tmc** - Short-lived clusters provisioned via TMC
 - app-best-4
 - app-best-7
 - app-best-10
 - tkg-eric-clusterX
 - tkgs-kirti-cluster1
 - tester333
- **demo** - Short-lived Clusters for demos
 - vdsdemo1 - demo cluster
- **workload** - Long-lived clusters
 - tbs2 - Tanzu Build Service
 - tbs3 - TAnzu Build Service
 - extdemo - TKG extensions, yelb, etc.
