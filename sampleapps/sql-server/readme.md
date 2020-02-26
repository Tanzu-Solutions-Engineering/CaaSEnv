### SQL Server on Linux

Deploy: kubectl apply -f .

#### YAML files

* sc.yaml - Creates StorageClass named 'vsan'
* secret.yaml - Creates secret named 'SA_PASSWORD' used by the deployment
* pvc.yaml - Created 8Gi PV named mssql-data
* deploy.yaml - Creates a deployment with a pod based on 'mcr.microsoft.com/mssql/server:2017-latest' that mounts the pv.
* svc.yaml - Creates LoadBalancer for TCP1433 to the MSSQL pod


#### Notes
* Keep the MSSQL_SA_PASSWORD Environment variable in order to bypass an issue with IPv6 
