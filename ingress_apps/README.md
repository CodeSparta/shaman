# ingress_apps
This module is used for creating the route53 record for the ingress loadbalancer
used by openshift applications.

## What's it doing
The module is called during the task execution of konductor after the controlplane and 
route53 modules execute. The module will wait for the classic loadbalancer to get created
by the openshift-ingress-operator and will then create a corresponding route53 record.
