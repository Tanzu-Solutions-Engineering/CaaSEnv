### configdata

This folder contains subfolder; each of which represents a foundation deployment to the environment


Each Foundation folder contains the following subfolders:

* config - base configuration yaml for products
* env - connection information for Ops manager
* state - vSphere location information for OpsManager VM, empty state.yml when the ops mgr is removed
* vars - Deployment-specific information per product.  Each product may have a defaults fie and a vars file.

#### IMPORTANT - PASSWORDS/SECRETS MUST BE KEPT IN CREDHUB, NOT IN THESE FILES
