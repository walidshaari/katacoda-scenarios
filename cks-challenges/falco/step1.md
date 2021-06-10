# Install k3s

The first step is installing k3s. 

k3s, the easy to install, lightweight Kubernetes distribution.

For more information, check out https://k3s.io and https://github.com/rancher/k3s/blob/master/README.md.

k3s consists of a server(control plane components)  and an agent (worker node components).

- Host 1 (`master`) will function as server and will also join the cluster by running the agent.

There is a simple `curl` oneliner to install k3s.

`curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.20.0+k3s2 sh -`{{execute}}

You can run the following command to check if the node is in Ready state (you might need to run the command a couple of times, can take up to 30 seconds for the node to register):

`k3s kubectl get node`{{execute T1}}

For your convenience, the following command will wait until the node shows up as `Ready`:

`until k3s kubectl get node 2>/dev/null | grep master | grep -q ' Ready'; do sleep 1; done; k3s kubectl get node`{{execute}}

As soon as it shows `master` with status `Ready`, you have built your single host cluster!

```
NAME     STATUS   ROLES    AGE   VERSION
master   Ready    <none>   28s   v1.20.0+k3s2
```

