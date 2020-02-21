### Windows Sample Apps


#### ASP.NET Private/Public

This uses the Microsoft .NET Framework Sample ASP.Net image.  
**Note** that this image is **8.08 GB**

* aspnetpublic.yaml pulls the image from the internet
* aspnetprivate.yaml pulls the image from local harbor repo
  * **Note** there must be a docker-registry secret named *harbor* in the target namespace
  * **Note** the TLS certificate for Harbor must be added to the Windows Worker Nodes certstore:  [Procedure Here](https://brianragazzi.wordpress.com/2019/09/10/adding-a-private-docker-registry-to-a-pks-1-5-windows-kubernetes-cluster/)

To access the application after deployment:
1. Identify the IP address of the Windows Worker nodes `kubectl get nodes -o wide`
2. Identify the TCP port used by the NodePort `kubectl get svc -n test aspnetapp -o jsonpath='{.spec.ports[0].nodePort}'`
3. Point browser to http://*WORKER-NODE-IP*:*node-port-id
