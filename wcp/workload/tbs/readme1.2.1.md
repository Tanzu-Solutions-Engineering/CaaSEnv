# TBS 1.2.1

# Preparation
  07/8/21
  On TKGS, the target TKG cluster should be running v1.18.5 or v1.19.7 or 1.20.7 and have 40GB volumes mounted at /var/lib/containerd on the workers
  See example https://github.com/Tanzu-Solutions-Engineering/CaaSEnv/blob/master/wcp/workload/tbs1.yaml

## Add PSP
kubectl apply -f allowrunasnonroot-clusterrole.yaml


# relocate images:
docker login -u bragazzi@caas.pez.pivotal.io harbor.caas.pez.pivotal.io
Not needed? kbld relocate -f ./images.lock --lock-output ./images-relocated.lock --registry-verify-certs=false --repository harbor.caas.pez.pivotal.io/build-service/tbs
```
imgpkg copy -b "registry.pivotal.io/build-service/bundle:1.2.1" --to-repo harbor.caas.pez.pivotal.io/tbs/build-service --registry-ca-cert-path ./caas-root-ca.cer --include-non-distributable-layers
imgpkg pull -b "harbor.caas.pez.pivotal.io/tbs/build-service:1.2.1" -o /tmp/bundle --registry-ca-cert-path ./ca.cer
```
# Deploy
```
ytt -f /tmp/bundle/values.yaml \
    -f /tmp/bundle/config/ \
    -f caas-root-ca.cer \
    -v docker_repository="harbor.caas.pez.pivotal.io/tbs/build-service" \
    -v docker_username="username@caas.pez.pivotal.io" \
    -v docker_password="password" \
    -v tanzunet_username="username@pivotal.io" \
    -v tanzunet_password='password' \
    | kbld -f /tmp/bundle/.imgpkg/images.yml -f- --registry-ca-cert-path caas-root-ca.cer \
    | kapp deploy -a tanzu-build-service -f- -y
```
or - without dynamic updates to clusterstacks - include the CA CERT!!
```
ytt -f /tmp/bundle/values.yaml \
    -f /tmp/bundle/config/ \
    -f caas-root-ca.cer \
    -v docker_repository="harbor.caas.pez.pivotal.io/tbs/build-service" \
    -v docker_username="username@caas.pez.pivotal.io" \
    -v docker_password='password' \
    | kbld -f /tmp/bundle/.imgpkg/images.yml -f- --registry-verify-certs=false \
    | kapp deploy -a tanzu-build-service -f- -y
```

# Verify
kapp inspect -a tanzu-build-service



# Dependencies

kp import -f ./descriptor-<version>.yaml --registry-ca-cert-path <path-to-ca-cert>


## Two-Step for dependencies
** You may have to change context and change back to get this to work

kbld package -f ./descriptor-100.0.146.yaml --output /tmp/packaged-dependencies.tar

kbld unpackage -f descriptor-100.0.146.yaml \
  --input /tmp/packaged-dependencies.tar \
  --repository harbor.caas.pez.pivotal.io/tbs/build-service \
  --lock-output ./dependencies-relocated.lock \
  --registry-ca-cert-path ./ca.crt

kbld -f ./descriptor-100.0.122.yaml -f ./dependencies-relocated.lock | kp import -f - --registry-ca-cert-path ./ca.crt
or
kbld -f ./descriptor-100.0.80.yaml -f ./dependencies-relocated.lock >./dep-import.yaml
kp import -f ./dep-import.yaml --registry-ca-cert-path ./ca.crt --registry-verify-certs false

## Check Readiness
Check that the "smart-warmer-image-fetcher" pods in the build-service namespace are running
If not, see if they are timing out pulling images from Harbor
see: https://kb.vmware.com/s/article/82667


# Create sample image
kp secret create harbor-creds --registry harbor.caas.pez.pivotal.io --registry-user "bragazzi@caas.pez.pivotal.io"

kp image create tbs-java-maven --tag harbor.caas.pez.pivotal.io/tbs/test-app --git https://github.com/buildpacks/samples --sub-path ./apps/java-maven --registry-ca-cert-path caas-root-ca.cer --wait



## troubleshoot
kp build status tbs-java-maven
kp image status tbs-java-maven
kp build logs tbs-java-maven


#remove tbs
kapp delete -a tanzu-build-service -y
