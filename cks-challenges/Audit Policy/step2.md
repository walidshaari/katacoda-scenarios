


## stages

## levels

## core and Named API groups

## things to watch for


### Enabling auditing
```
    - --audit-policy-file=/etc/kubernetes/audit/policy.yaml       # add
```
### Audit log Attributes
```
    - --audit-policy-file=/etc/kubernetes/audit/policy.yaml       # add
    - --audit-log-path=/etc/kubernetes/audit/logs/audit.log       # add
    - --audit-log-maxsize=500                                     # add
    - --audit-log-maxbackup=5                                     # add
```
### Ensuring correct Volumes and volumeMounts

    for both the audit policy file and audit log file there should a corresponding *hostpath* *volume* (could be one if they share the same directory) 
    as well as a corresponding  *mountVolume*


