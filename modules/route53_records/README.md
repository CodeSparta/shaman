# Terraform Route Module
Terraform module used for creating route53 A,CNAME and SRV records.

## Requirements:
A route53 zone must exist for this module to execute successfully.

This module is used to generate route53 entries for the following:

| record_name | record_type | record_example
|----|----|----|
| etcd-[index].{cluster_name}.{cluster_domain} | A | etcd-0.cluster.redhat.com |
| _etcd-server-ssl._tcp | SRV | 0 10 2830 etcd-0.cluster.redhat.com |
| api | CNAME | api.cluster.redhat.com > api.[network_loadbalancer].fqdn | 

## How to use it:
```
terraform init 
terraform plan
terraform apply 
```

## Use terraform state to destroy
```
terrafom destroy
```
