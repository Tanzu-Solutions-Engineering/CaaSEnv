# TBS 1.3.0
# 11/2/21


## Add PSP
kubectl apply -f allowrunasnonroot-clusterrole.yaml


# relocate images:
docker login -u bragazzi@caas.pez.pivotal.io harbor.caas.pez.pivotal.io --tlscacert ./caas-root-ca.cer
docker login registry.tanzu.vmware.com

```
imgpkg copy -b "registry.pivotal.io/build-service/bundle:1.3.0" --to-repo harbor.caas.pez.pivotal.io/tbs/build-service --registry-ca-cert-path ./caas-root-ca.cer --include-non-distributable-layers
imgpkg pull -b "harbor.caas.pez.pivotal.io/tbs/build-service:1.3.0" -o /tmp/bundle --registry-ca-cert-path ./caas-root-ca.cer
```
# Deploy - passing the tanzuNet credentials enables the automatic dependency updater
```
ytt -f /tmp/bundle/values.yaml \
    -f /tmp/bundle/config/ \
    -f ./caas-root-ca.cer \
       -v kp_default_repository="harbor.caas.pez.pivotal.io/tbs/build-service" \
       -v kp_default_repository_username="username@caas.pez.pivotal.io" \
       -v kp_default_repository_password="password" \
       -v tanzunet_username="username@pivotal.io" \
       -v tanzunet_password='Password' \
       | kbld -f /tmp/bundle/.imgpkg/images.yml -f- --registry-ca-cert-path caas-root-ca.cer \
       | kapp deploy -a tanzu-build-service -f- -y
```

# Verify
```
kapp inspect -a tanzu-build-service
kp clusterbuilder list
kp clusterstack list
kp clusterstore status default
```
## check that dependencyupdater is enabled:
```
kubectl get TanzuNetDependencyUpdater -A
```


## Check Readiness
Check that the "smart-warmer-image-fetcher" pods in the build-service namespace are running
```
 k get po -n build-service -l app=build-pod-image-fetcher
```
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
