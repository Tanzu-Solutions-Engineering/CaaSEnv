
## Steps

# Apply cert-manager/01-namespaces.yaml and cert-manager/02-cert-manager.yaml

# edit 02-certs-self-signed.yaml by listing the ip addresses of the control-plane nodes for the cluster that will run dex under the spec.ipAddresses element

# edit 03-cm.yaml:
#* edit IP address in line 8 with the ip from one of the control plane nodes.  Keep the 30167 port number
#* edit data.config.yaml.connectors.config.host value to the fqdn and port number of the LDAP server
#* edit data.config.yaml.connectorss.config.userSearch.baseDN value to the correct DN to start lookups in LDAP.
#* edit data.config.yaml.connectorss.config.userSearch.username to "userPricipalName" for Active Directory
#* edit data.config.yaml.connectorss.config.userSearch.idAttr to "userPricipalName" for Active Directory
#* edit data.config.yaml.connectorss.config.userSearch.emailAttr to "email" for Active Directory
#* edit data.config.yaml.connectorss.config.userSearch.nameAttr to "displayName" for Active Directory
#* edit data.config.yaml.connectorss.config.groupSearch.baseDN value to the correct DN to start group lookups in LDAP.
#* edit data.config.yaml.connectorss.config.groupSearch.userAttr to "displayName" for Active Directory
#* edit data.config.yaml.connectorss.config.groupSearch.groupAttr to "member" for Active Directory
#* edit data.config.yaml.connectorss.config.groupSearch.nameAttr to "cn" for Active Directory
