### pkswin

This foundation will include PKS with Windows support


#### Generate Certificates in CredHub:

* credhub generate --type certificate -n /foundation/pkswin/harbor_server_cert --self-sign --common-name harbor.pkswin.caas.pez.pivotal.io
* credhub generate --type certificate -n /foundation/pkswin/pivotal-container-service_pks_tls --self-sign --common-name api.pks.pkswin.caas.pez.pivotal.io
* credhub generate --type=ssh -n /foundation/pkswin/opsman_ssh -m opsman_ssh


##### NO PASSWORDS/SECRETS/PRIVATE KEYS IN HERE
All private data must be kept in credhub.  

files in `vars` and `env` folders will be interpolated against credhub, so ((placeholders)) get replaced with values from credhub
