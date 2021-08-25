# Harbor Extension

## Prerequisites

* Workload Cluster deployed.
* Contour Extension installed in the Workload Cluster.

### Install Harbor Extension

1. Install TMC Extension Manager

    ```sh
    kubectl apply -f ../tmc-extension-manager.yaml
    ```

2. Install kapp-controller

    ```sh
    kubectl apply -f ../kapp-controller.yaml
    ```

3. Create namespace and roles for Harbor extension

    ```sh
    kubectl apply -f namespace-role.yaml
    ```

4. Review and modify `harbor-data-values.yaml` as needed


5. Create a secret with data values

    ```sh
    kubectl create secret generic harbor-data-values --from-file=values.yaml=harbor-data-values.yaml -n tanzu-system-registry
    ```

6. Deploy Harbor Extension

    ```sh
    kubectl apply -f harbor-extension.yaml
    ```

7. Retrieve the status of Harbor Extension

    ```sh
    kubectl get extension harbor -n tanzu-system-registry
    kubectl get app harbor -n tanzu-system-registry
    ```

   The Harbor App status should change to `Reconcile succeeded` once Harbor is deployed successfully.

   View detailed status:

   ```sh
   kubectl get app harbor -n tanzu-system-registry -o yaml
   ```

### Update Harbor Extension

1. Use the previous applied harbor-data-values.yaml or get Harbor data values from the secret

    ```sh
    kubectl get secret harbor-data-values -n tanzu-system-registry -o 'go-template={{ index .data "values.yaml" }}' | base64 -d > harbor-data-values.yaml
    ```

2. Update Harbor configuration in harbor-data-values.yaml

3. Update harbor-data-values secret

    ```sh
    kubectl create secret generic harbor-data-values --from-file=values.yaml=harbor-data-values.yaml -n tanzu-system-registry -o yaml --dry-run | kubectl replace -f-
    ```

   Harbor extension will be reconciled again with the above data values.

   **NOTE:**
   By default, kapp-controller will sync apps every 5 minutes. So, the update should take effect in <= 5 minutes.
   If you want the update to take effect immediately, change syncPeriod in `harbor-extension.yaml` to a lesser value
   and apply harbor extension `kubectl apply -f harbor-extension.yaml`.

4. Retrieve the status of Harbor Extension

   Refer to `Retrieve the status of Harbor Extension` in section [Install Harbor extension](#install-harbor-extension).

### Uninstall Harbor Extension

1. Delete Harbor Extension

    ```sh
    kubectl delete -f harbor-extension.yaml
    kubectl delete app harbor -n tanzu-system-registry
    ```

2. Retrieve the status of Harbor Extension

   Refer to `Retrieve the status of Harbor Extension` in section [Install Harbor extension](#install-harbor-extension). If Harbor Extension is deleted successfully, then getting Harbor App will show `not found`.

3. Delete Harbor namespace

   **NOTE: Do not delete namespace-role.yaml before app is deleted fully, as it will lead to errors due to service account used by kapp-controller being deleted**

    ```sh
    kubectl delete -f namespace-role.yaml
    ```

### Test template rendering

1. Test if Harbor ytt templates are rendered correctly

    ```sh
    ytt --ignore-unknown-comments -f ../../../common -f ../../../registry/harbor -f harbor-data-values.yaml
    ```
