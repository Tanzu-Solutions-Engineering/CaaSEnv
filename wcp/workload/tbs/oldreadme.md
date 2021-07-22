# Preparation
  03/16/21
  On TKGS, the target TKG cluster should be running v1.18.5 and have 40 volumes mounted at /var/lib/containerd on the workers
  See example https://github.com/Tanzu-Solutions-Engineering/CaaSEnv/blob/master/wcp/workload/tbs1.yaml



# relocate images:
This will pull the images down and push them into the repo here:
```
kbld relocate -f ./images.lock --lock-output ./images-relocated.lock --registry-verify-certs=false --repository harbor.caas.pez.pivotal.io/build-service --concurrency 1
```

# Deploy
This uses kapp to install TBS from the repo
```
ytt -f ./values.yaml \
    -f ./manifests/ \
    -f ./ca.crt \
    -v docker_repository="harbor.caas.pez.pivotal.io/build-service" \
    -v docker_username="bragazzi@caas.pez.pivotal.io" \
    -v docker_password="<PASSWORD>" \
    | kbld -f ./images-relocated.lock -f- --registry-verify-certs=false \
    | kapp deploy -a tanzu-build-service -f- -y
```

## Validate
```
kapp inspect -a tanzu-build-service
```

# Dependencies
After installing the TBS, add the Dependencies, first pull them down and push into repository
```
kp import -f ./descriptor-<version>.yaml --registry-ca-cert-path <path-to-ca-cert>
```
If that fails - because you're trying to move a lot of data over VPN for example, try the multi step version

## Multi-Step
  ** You may have to change context and change back to get this to work
  Download the images and tar them up
  ```
  kbld package -f ./descriptor-<version>.yaml --output ./packaged-dependencies.tar
  ```
  Extract the tar to push and create the relocated.lock file
  ```
  kbld unpackage -f descriptor-100.0.80.yaml \
    --input /tmp/packaged-dependencies.tar \
    --repository 192.168.105.71/workload/build-service \
    --lock-output ./dependencies-relocated.lock \
    --registry-ca-cert-path ./ca.crt
  ```

  Import the images from repo into kp
  ```
  kbld -f ./descriptor-100.0.72.yaml -f ./dependencies-relocated.lock | kp import -f - --registry-ca-cert-path ./ca.crt
  ```

## Check Readiness
Check that the "smart-warmer-image-fetcher" pods in the build-service namespace are running
If not, see if they are timing out pulling imnages from Harbor
see: https://kb.vmware.com/s/article/82667


# Create sample image
## First set a secret for the repo:
```
kp secret create harbor-creds --registry 10.193.39.134 --registry-user "bragazzi@caas.pez.pivotal.io"
```
Then, use  either of these:
```
kp image create tbs-java-maven --tag 10.193.39.134/workload/test-app --git https://github.com/buildpacks/samples --sub-path ./apps/java-maven --wait
```
or
```
kp image create tbs-java-maven --tag 10.193.39.134/workload/test-app --git https://github.com/buildpacks/samples --sub-path ./apps/java-maven --registry-ca-cert-path ./ca.crt
```
# remove tbs
```
kapp delete -a tanzu-build-service -y
```
