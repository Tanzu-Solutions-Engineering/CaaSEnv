## Config repo for vSphere with Tanzu

## Login

### WCP
    kubectl vsphere login  --insecure-skip-tls-verify --server wcp.caas.pez.pivotal.io -u bragazzi@caas.pez.pivotal.io

### services1
    kubectl vsphere login --tanzu-kubernetes-cluster-name service1 --server wcp.caas.pez.pivotal.io --insecure-skip-tls-verify --tanzu-kubernetes-cluster-namespace sharedservices -u bragazzi@caas.pez.pivotal.io

### monitoring
    kubectl vsphere login --tanzu-kubernetes-cluster-name monitoring --server wcp.caas.pez.pivotal.io --insecure-skip-tls-verify --tanzu-kubernetes-cluster-namespace sharedservices -u bragazzi@caas.pez.pivotal.io

### database
    kubectl vsphere login --tanzu-kubernetes-cluster-name database --server wcp.caas.pez.pivotal.io --insecure-skip-tls-verify --tanzu-kubernetes-cluster-namespace workload -u bragazzi@caas.pez.pivotal.io
