

# relocate images:
kbld relocate -f /tmp/images.lock --lock-output /tmp/images-relocated.lock --registry-verify-certs=false --repository 10.193.39.134/workload/build-service


# Deploy

ytt -f /tmp/values.yaml \
    -f /tmp/manifests/ \
    -f /tmp/ca.crt \
    -v docker_repository="10.193.39.134/workload/build-service" \
    -v docker_username="bragazzi@caas.pez.pivotal.io" \
    -v docker_password="<PASSWORD>" \
    | kbld -f /tmp/images-relocated.lock -f- --registry-verify-certs=false \
    | kapp deploy -a tanzu-build-service -f- -y



# Dependencies

kp import -f /tmp/descriptor-<version>.yaml --registry-ca-cert-path <path-to-ca-cert>


# Two-Step
kbld package -f /tmp/descriptor-<version>.yaml --output /tmp/packaged-dependencies.tar

kbld -f /tmp/descriptor-100.0.72.yaml -f /tmp/dependencies-relocated.lock | kp import -f - --registry-ca-cert-path /tmp/ca.crt
