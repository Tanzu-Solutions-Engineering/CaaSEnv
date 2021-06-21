# CaaS Operational Repo

The goal of this repo to keep a consistent record of all the changes in the CaaS environment.

You will find a log of changes as well as what we hope will be a series of cookbooks on maintaining the environment.

Please check out the [ChangeLog.md](https://github.com/Pivotal-Field-Engineering/CaaSEnv/blob/master/ChangeLog.md) to see the latest maintenance.  

## Namespaces and Clusters

- **sharedservices** - Clusters hosting common Services
 - harbor2 - Harbor for TKGS
 - mysql - Tanzu SQL with mySQL
 - postgres - Tanzu SQL with postgres
- **test-tmc** - Clusters provisioned via TMC
- **test-web** - Clusters for demos
 - vdsdemo1 - demo cluster
- **workload** - Long-living clusters
 - tbs2 - Tanzu Build Service
 - tbs3 - TAnzu Build Service
