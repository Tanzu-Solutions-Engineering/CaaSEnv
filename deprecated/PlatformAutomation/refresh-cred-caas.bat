

credhub api -s 10.193.38.51:8844 --skip-tls-validation
credhub login -u credhub -p FHG2UwqyL*X}ZyuGBfr9

REM credhub import -f ./private-caas-tkgi.yml

REM credhub generates the PW for us
REM credhub generate -n foundation/tkgi/uaa_concoursepks_secret -t password

credhub export -f ./private-all-credhub-caas.yml
