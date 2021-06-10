


### Posibilities

Some of the possible questions you would expect regarding "Audit Policy" could be
-  Enable Audit Policy on a Kubernetes cluster
-  Tweek or add Audit policy log attributes (Maximum age, number of backups, log file size, file path)
-  Tweek or create a new Audit policy according to certain specs

### Resources:
k8s docs: 


### Pay Attention to:
- The current Audit policy settings
- The Audit policy file
- The need for a tool e.g. jq (provided in the exam enviornment) to read events
- The kube-apiserver health and its senstivity to changes and mistakes in the static manifest file 
- The volumes and mountedVolumes resoruces related to the policy
- Events produced and order of rules in policy

## try out
- What if you change rule orders?
- What if you change the level?
- what about secret and senstive data? how should it be logged (level, stage, resources)?


