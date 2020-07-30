### TKGI

This foundation will include TKGI 1.7+ with NSX-T integration


#### Generate Certificates in CredHub:

* credhub generate --type certificate -n /foundation/tkgi/harbor_server_cert --self-sign --common-name harbor.tkgi.caas.pez.pivotal.io
* credhub generate --type certificate -n /foundation/tkgi/pivotal-container-service_pks_tls --self-sign --common-name api.pks.tkgi.caas.pez.pivotal.io
* credhub generate --type=ssh -n /foundation/tkgi/opsman_ssh -m opsman_ssh


##### NO PASSWORDS/SECRETS/PRIVATE KEYS IN HERE
All private data must be kept in credhub.  

files in `vars` and `env` folders will be interpolated against credhub, so ((placeholders)) get replaced with values from credhub
