## Step 1
First, have to get into the Opsman API.  Follow reference here: https://docs.pivotal.io/pivotalcf/2-5/customizing/ops-man-api.html#opsman_login
1. SSH to opsman vm.  
    1. ssh ubuntu@opsmgr.caas.pez.pivotal.io.  Password is the usual team password (see LastPass)
2. Now get the token: 
`ubuntu@pks-ops-manager:~$ uaac token owner get`
```
Client ID:  opsman
Client secret: <leave this blank> 
User name:  admin
Password: ****
```
   
Now you have to copy the token.  Use the command `“uaac contexts”` and look for the token with `client_id: opsman`
```
ubuntu@pks-ops-manager:~$ uaac contexts
[0] [https://api.pks.caas.pez.pivotal.io:8443]
  skip_ssl_validation: true
  [0] [admin]
… <deleted> ...
  
[1]*[https://opsmgr.caas.pez.pivotal.io/uaa]
  skip_ssl_validation: true
  [0]*[admin]
      user_id: f1f2d163-2ff8-483d-b415-4c098b84690b
      client_id: opsman
      access_token: ****
```
*Optional:  To test if the key is right, you need to get a list of deployed products using this code (NOTE: the ‘-k’ is to avoid curl validation):*
```
curl "https://opsmgr.caas.pez.pivotal.io/api/v0/deployed/products" -X GET -H "Authorization: Bearer $YOUR-UAA-ACCESS-TOKEN" -k
```
Response looks like
```
[{"installation_name":"harbor-container-registry-adc6ebace1f8cd262f41","guid":"harbor-container-registry-adc6ebace1f8cd262f41","type":"harbor-container-registry","product_version":"1.8.1-build.4","label":"VMware Harbor Registry","service_broker":false,"stale":{"parent_products_deployed_more_recently":["p-bosh-3b1f714c2d292c9f981b"]}},{"installation_name":"p-bosh","guid":"p-bosh-3b1f714c2d292c9f981b","type":"p-bosh","product_version":"2.5.13-build.232","label":"BOSH Director","service_broker":false,"stale":{"parent_products_deployed_more_recently":[]}},{"installation_name":"pivotal-container-service-b33d59a4a4a84d8064c7","guid":"pivotal-container-service-b33d59a4a4a84d8064c7","type":"pivotal-container-service","product_version":"1.5.1-build.8","label":"Enterprise PKS","service_broker":true,"stale":{"parent_products_deployed_more_recently":[]
```

## Step 2
Reference Pivotal Docs:  https://docs.pivotal.io/pivotalcf/2-6/security/pcf-infrastructure/api-cert-rotation.html 

Run this command to get OpsManager root certifcate (for the sake of space, I'm using YOUR-UAA-ACCESS-TOKEN in place of that huge token above)
```
curl "https://opsmgr.caas.pez.pivotal.io/api/v0/certificate_authorities" -H "Authorization: Bearer YOUR-UAA-ACCESS-TOKEN” -k
```
Returns both Opsman and NATS 
```
{"certificate_authorities":[{"guid":"e790041ee8581c6611a9","issuer":"Pivotal","created_on":"2018-11-26T16:56:02Z","expires_on":"2022-11-26T16:56:02Z","active":true,"cert_pem":"-----BEGIN CERTIFICATE-----

   < omitted >
```
Note that get expired date.  In this case, it is **"expires_on":"2022-11-26T16:56:02Z"**, so years away from the time of this writing.  In the block there will also be the cert for NATs, identified as `nats_cert_pem`.  It may also be expired.  If the OpsMan cert is expired, follow the directions here to rotate.

If the main cert is good, time to check the leaf certs.  You can use the same api endpoints with the extension “deployed/certificates”.  A neat trick too check which one are expiring within 6 months is to run this command:
```
curl "https://OPS-MAN-FQDN/api/v0/deployed/certificates?expires_within=6m" \
      -H "Authorization: Bearer YOUR-UAA-ACCESS-TOKEN” -k | jq '.'
```
The results were nicely formated.  Alternately, you could copy the output into a text file, save as JSON, and view in Firefox or some other viewer.
```
{
  "certificates": [
    {
      "configurable": false,
      "property_reference": null,
      "property_type": null,
      "product_guid": null,
      "location": "credhub",
      "variable_path": "/bosh_dns_health_server_tls",
      "issuer": "/CN=opsmgr-bosh-dns-tls-ca",
      "valid_from": "2018-11-27T19:12:06Z",
      "valid_until": "2019-11-27T19:12:06Z"
    },
    {
      "configurable": false,
      "property_reference": null,
      "property_type": null,
      "product_guid": null,
      "location": "credhub",
      "variable_path": "/bosh_dns_health_client_tls",
      "issuer": "/CN=opsmgr-bosh-dns-tls-ca",
      "valid_from": "2018-11-27T19:12:06Z",
      "valid_until": "2019-11-27T19:12:06Z"
    },
    {
      "configurable": false,
      "property_reference": null,
      "property_type": null,
      "product_guid": null,
      "location": "credhub",
      "variable_path": "/dns_api_server_tls",
      "issuer": "/CN=opsmgr-bosh-dns-tls-ca",
      "valid_from": "2018-11-27T19:12:07Z",
      "valid_until": "2019-11-27T19:12:07Z"
    },
    {
      "configurable": false,
      "property_reference": null,
      "property_type": null,
      "product_guid": null,
      "location": "credhub",
      "variable_path": "/dns_api_client_tls",
      "issuer": "/CN=opsmgr-bosh-dns-tls-ca",
      "valid_from": "2018-11-27T19:12:07Z",
      "valid_until": "2019-11-27T19:12:07Z"
    }
  ]
```

## Step 3
In this case, they are non-configurable, so I have to run a curl command and then go into OpsManager to apply changes:
From docs:
```
curl "https://opsmgr.caas.pez.pivotal.io/api/v0/certificate_authorities/active/regenerate" \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{}' \
    -H "Authorization: Bearer YOUR-UAA-ACCESS-TOKEN" -k
```

Then went to OpsMan and `Apply Changes` (just for BOSH.  Uncheck PKS and Harbor)

Check the `CHANGE LOG` in Ops Manager to confirm success

That's it.
