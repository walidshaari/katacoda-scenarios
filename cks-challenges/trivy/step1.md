
## Install Trivy using from AquaSecurity github repo

- Check out the different [installation methods](https://aquasecurity.github.io/trivy/v0.18.3/installation/)

  `curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh |sh -s -- -b /usr/local/bin`{{execute}}


- Deploy lightweight kubernetes k3s with some sample apps(deployment
  
  Using the generic install script method, will install a single node k3s cluster:
  `curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.20.0+k3s2 sh -`{{execute}}
   
   Check Cluster node readines:
   `kubectl get nodes -o wide`{{execute}}

   Deploy sample apps:
   `kubectl -f ./deployments`{{execute}}  


