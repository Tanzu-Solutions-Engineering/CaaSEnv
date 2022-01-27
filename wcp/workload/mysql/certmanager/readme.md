kubectl -n mysql-instances create secret generic ca-key-pair \
  --from-file=tls.crt=../tls/root64.cer \
  --from-file=tls.key=../tls/private.key
