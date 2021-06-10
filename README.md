# Interactive Katacoda Scenarios

[![](http://shields.katacoda.com/katacoda/walidshaari/count.svg)](https://www.katacoda.com/walidshaari "Get your profile on Katacoda.com")

Visit https://www.katacoda.com/walidshaari to view the profile and interactive scenarios

### Writing Scenarios
Visit https://www.katacoda.com/docs to learn more about creating Katacoda scenarios

For examples, visit https://github.com/katacoda/scenario-example


## Update on KataCoda (in-progress)

As I had issues with limits with katacoda.com and was not able to create these scenarios on katacod due to these limits and the lack of support, I have created the below file with hints regardin these area of the CKS exam, will work on Katacoda or Instruqt. [Instruqt](https://instruqt.com/katacoda-alternative-flexible-content-creation/) is quite promising as it has more flexibility in how your create your enviornment and its life cycle, however needs a sponsorship. if you are interested in creating such a content in Instruqt, and would like to help, let me know 


- video of the [Exam environment preview](https://www.youtube.com/watch?v=9UqkWcdy140)

   ![exam environment](images/ExamEnvPreview.png)

- practice on killer.sh when you are ready before the exam at least a week

   ![killer.sh](images/killer.shell-include.png)
   
 

- Ensure you address the right namespace and cluster always
- Do not overthink it
- Get familiar with the options you need and files
- spelling mistakes
- journalctl -u kubelet  or -u falco
- `cat /var/log/pods`  or `/var/log/containers` or `crictl ps -a`  or `crictl logs`
- Make sure you backup the apiserver before working on it
  - and try to break it and see errors and you investigate them  https://itnext.io/cks-exam-series-4-crash-that-apiserver-5f4d3d503028  and #Klustered might help


## The mindset: What to expect in CKS
- Webinar: The Certified Kubernetes Security Specialist: What to Know and How to Pass 

  https://youtu.be/Ny3p0UKBcYs  by StackRox/Michael Foster. now with Red Hat and runs a weekly security show
  
- DSO Overflow Podcast special espisdoe on K8s certifications https://dsooverflow.buzzsprout.com/733070/8265436-ep08-kubernetes-exam-cram
   Steve Giguere and Michael Foster, the hosts from Clust3rF8ck.
   
 
  

# 1 -kube-bench

in killer.sh platform:

`kubectl config use-context infra-prod`

`source <(kubectl completion bash);alias k=kubectl;complete -F __start_kubectl`

## Worker and Control-plane nodes kubelet benchmark

   try to check the kubelet both in control-plane and worker nodes
   
   ```bash
   
     ssh cluster2-worker1
     kube-bench  node
   
   ``` 

   ![killer.sh](images/kube-bench-node.png)
   
   ![killer.sh](images/kubeconfig-perms.png)
  

   ```
    2.2.10 Run the following command (using the config file location identified in the Audit step)
    chmod 644 /var/lib/kubelet/config.yaml
   ```

`ls -ld /var/lib/kubelet/config.yaml`

`chmod 644 /var/lib/kubelet/config.yaml`

```
2.1.7 If using a Kubelet config file, edit the file to set protectKernelDefaults: true .
If using command line arguments, edit the kubelet service file
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf on each worker node and
set the below parameter in KUBELET_SYSTEM_PODS_ARGS variable.
--protect-kernel-defaults=true
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service

2.1.10 If using a Kubelet config file, edit the file to set eventRecordQPS: 0 .
If using command line arguments, edit the kubelet service file
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf on each worker node and
set the below parameter in KUBELET_SYSTEM_PODS_ARGS variable.
--event-qps=0
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service
```

https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook

### Admission Configuration file
/etc/kubernetes/kube-image-bouncer/admission_configuration.yaml
  ```yaml
  ---
  imagePolicy:
    kubeConfigFile: "/etc/kubernetes/kube-image-bouncer/kube-image-bouncer-config.yaml"
    allowTTL: 50
    denyTTL: 50
    retryBackoff: 500
    defaultAllow: true
  ```
### kubeconfig for the admission controller
/etc/kubernetes/kube-image-bouncer/kube-image-bouncer-config.yaml
```yaml

```

### Validation Webhook configuration
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: image-bouncer-webook
webhooks:
  - name: image-bouncer-webhook.default.svc
    rules:
      - apiGroups:
          - ""
        apiVersions:
          - v1
        operations:
          - CREATE
        resources:
          - pods
    failurePolicy: Ignore
    sideEffects: None
    admissionReviewVersions: ["v1", "v1beta1"]
    clientConfig:
      caBundle: $(kubectl get csr image-bouncer-webhook.default -o jsonpath='{.status.certificate}')
      service:
        name: image-bouncer-webhook
        namespace: default
```

# 2 -gvisor   Q10


RuntimeClass
https://kubernetes.io/docs/concepts/containers/runtime-class/#2-create-the-corresponding-runtimeclass-resources


kubectl create namespace sandbox

```
apiVersion: node.k8s.io/v1  # RuntimeClass is defined in the node.k8s.io API group
kind: RuntimeClass
metadata:
  name: myclass  # The name the RuntimeClass will be referenced by
  # RuntimeClass is a non-namespaced resource
handler: runsc  # The name of the corresponding CRI configuration runsc for gvisor
```

`kubectl create -f myclass-rtc.yaml`

```
piVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: sandbox
  name: sandbox
  namespace: sandbox
spec:
  replicas: 2
  selector:
    matchLabels:
      app: sandbox
  template:
    metadata:
      labels:
        app: sandbox
    spec:
      nodeSelector:                               # ensure  the node that has runsc configured 
        kubernetes.io/hostname: cluster1-worker2
      runtimeClassName: myclass                   # ensure the right runtimeClass
      containers:
      - image: nginx
        name: nginx
```


# 3-trivy



# -ImagePolicyWebhook

https://github.com/kainlite/kube-image-bouncer


- creating service CSR and signing and approving it via k8s CA
```bash

k8s@terminal:~/ImagePolicyWebhook$ k get pods -o wide image-bouncer-webhook 
NAME                    READY   STATUS    RESTARTS   AGE   IP          NODE               NOMINATED NODE   READINESS GATES
image-bouncer-webhook   1/1     Running   0          18m   10.36.0.9   cluster1-worker2   <none>           <none>


k8s@terminal:~/ImagePolicyWebhook$ k get svc image-bouncer-webhook -o wide
NAME                    TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE     SELECTOR
image-bouncer-webhook   ClusterIP   10.97.32.96   <none>        443/TCP   4m50s   app=image-bouncer-webhook

k8s@terminal:~/ImagePolicyWebhook$ cat image-bouncer-webhook.csr 
{
  "hosts": [
    "image-bouncer-webhook.default.svc",
    "image-bouncer-webhook.default.svc.cluster.local",
    "image-bouncer-webhook.default.pod.cluster.local",
    "10.97.32.96",
    "10.36.0.9"
  ],
  "CN": "system:node:image-bouncer-webhook.default.pod.cluster.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "O": "system:nodes"
    }
  ]
}


cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: image-bouncer-webhook.default
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kubelet-serving
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
```   
   

# 4 - Audit Policy  Q17
- remmber the options in kube-api server

- remmber the volume and volumeMounts and readonly either not set or set to False

- remmber Stages, levels and omitstage

- Know how to troubleshoot the API server as you might break it
  - what if policy is wrong
  - What if missing volume
  - what if api-server options misconigred ( extra space)

- Order matters in Audit policy rules
```yaml
# Example Audit policy 
# Example audit policy from the O'rielly book "Production Kubernetes" Chapter 9
# with commentry from @walidshaari
# 9th June 2021  k8s v1.20.7
# to find which resource belongs to which APIGroup use "kubectl api-resources"

apiVersion: audit.k8s.io/v1
kind: Policy
rules:                           #Order is important when evaluting below Audit rules, start with None and usually finish with catch all
- level: None                    # None auditing level means the API server will not log events 
  users: ["system:kube-proxy"]   # for users system:kube-proxy
  verbs: ["watch"]               # when requesting watch on listed resources 
  resources:
  - group: ""                    # from core API group: endpoints, services and subresource for service status
    resources: ["endpoints", "services", "services/status"]  

- level: Metadata    
  resources:
  - group: ""
    resources: ["secrets", "configmaps"]
  - group: authentication.k8s.io
    resources: ["tokenreviews"]
  omitStages:                    # be careful and pay attention to identation
  - "RequestReceived"

- level: Request    
  verbs: ["get", "list", "watch"]  
  resources:  
  - group: ""  
  - group: "apps"  
  - group: "batch"  
  omitStages:  
  - "RequestReceived"

- level: RequestResponse    
  resources:  
  - group: ""  
  - group: "apps"  
  - group: "batch"  
  omitStages:  
  - "RequestReceived" # Default level for all other requests.


- level: Metadata    
  omitStages:  ["RequestReceived"]   # a differnet YAML  way to express arrays and ease reading 
```



# 5 - Falco
Falco is an open source project for intrusion and abnormality detection for Cloud Native platforms such as Kubernetes, Mesosphere, and Cloud Foundry.
It can detect abnormal application behavior, and alert via Slack, Fluentd, NATS, and more.

In this lab you will learn the basics of Falco and how to use it along with a Kubernetes cluster to detect anomalous behavior.

This scenario will cover the following security threats:

Unauthorized process
Write to non authorized directory
Processes opening unexpected connections to the Internet
You will play both the attacker and defender (sysadmin) roles, verifying that the intrusion attempt has been detected by Falco and how to customize Falco output.

## Need to focus on 
- How to read Falco/sysdig logs
- How to customize Falco events
- Get familiar with falco rules:
  -   `falco -L`
       use it to filter or check a specific types of attacks you are investigating e.g remote `falco -L|grep  remote` or package related `falco -L|grep package` 
  -   `grep 'rule:' /etc/falco/falco_rules.yaml`   the old traditional way if you like
  
  -   your custom rules can go in here /etc/falco/falco_rules.local.yaml
- config file  `/etc/falco/falco.yaml`

- expermint with failures
  - what if rule is wrong  ( needs macro, or a list, or not an array item, open bracket/quote, identation)
- remmber to restart Falco service

## Deploy standalone falco installation in worker nodes at least

You could install Falco using Helm, or system packages, it matters to where the configuration file is, a system file or a configmap

This will result in a Falco Pod being deployed to each node, and thus the ability to monitor any running containers for abnormal behavior.


  In each worker node you have, or just one for the homelab, it couldbe the same as control-plane node
  
 
  ```
  #### on node01 worker node:
  curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
  echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
  apt-get update -y
  curl -s htt  curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
  echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
  apt-get update -y
  curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
  apt install falco
  systemctl enable falco --nowps://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
  apt install -y falco
  systemctl enable falco --now
  systemctl status -l falco
  ```
  
  ![Falco](images/Falco-start-status.png)
  
  This will result in a Falco Pod being deployed, and thus the ability to monitor any running containers for abnormal behavior in that node.
  
  
  ```
  docker login
  cat ~/.docker/config.json 
  kubectl create secret generic regcred --from-file=.dockerconfigjson=/root/.docker/config.json     --type=kubernetes.io/dockerconfigjson -n ping
  ```
  
  ```
  #step 5 add additional rules
  cat custom_rules.yaml >> /etc/falco/falco_rules.local.yaml 
  cat /etc/falco/falco_rules.local.yaml 
  ```
  
  10:40:41.590238478: Error **Package management process** launched in container (user=root user_loginuid=-1 command=apt-get install locate container_id=4d6bc4b0265b **container_name=k8s_phpping_ping-74dbb488b6-4878h_ping_b51d5c6d-c9d1-11eb-a7f0-0242ac110009_0** **image=bencer/workshop-forensics-1-phpping:latest**)
  
  k8s_phpping_ping-74dbb488b6-4878h_ping_b51d5c6d-c9d1-11eb-a7f0-0242ac110009_0
  
  can be interpreted to   k8s_<CONTAINER-NAME>_<POD-NAME>_<POD-NAMESPACE>_<POD-UID>_<Container-RestartCount>
  Container Name: phpping_ping-74dbb488b6-4878h
  Pod Name: 
   
  ** k8s_CONTAINER-NAME_POD-NAME_POD-NAMESPACE_POD-UID_Container-RestartCount **
  
  



 # 6- OPA/GateKeeoer
- rego playfround 
- Styra Acadamy https://academy.styra.com/
  
    ![killer.sh](images/styra-academy.png)
 

