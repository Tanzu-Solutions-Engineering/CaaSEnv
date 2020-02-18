### CaaS Links

#### Images
* nginx
* busybox

#### Deploy.yaml
* Creates a deployment named 'CaaSLinks' that contains pod
* The pod contains one container using nginx
* The deployment uses a busybox initContainer to retrieve the linkspage.html content and save it to the html folder nginx uses

#### svc.yaml
* Creates a LoadBalancer service for the 'caaslinks' pods

#### Notes
* Number of Pods may be scaled

#### Content
is found in linkspage.html
