# ArgoCD

## Install
`
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
`

### Config LoadBalancer for ArgoCD
`
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
`

### Get admin Password:
`kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
`
