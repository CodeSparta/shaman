# fences-terraform

This is used to create the following:
- Security-groups 
- elb
- Registry-node
- control-plane

## Deployment environment 
The bastion box assumes it has an IAM role with the ability to create the ec2 instances, ELB and security groups. If keys are being used the user will need to modify the provider.tf file to the following:

```adil
provider "aws" {
  access_key = "my-access-key"
  secret_key = "my-secret-key"
  region  = var.aws_region
}
```



## Prereqs 
- VPC has been configured. 
- There are 3 Private subnets for AZ HA. 
- IAM roles have been created.
- P1 and OCP bundle have been executed.
- Public/Private SSH keypair is available 
## Setup the variable file 
### Mandatory
| Variable   | Default | Example | Comments (type)  |
| :---       | :---    | :---    | :---             |
| aws_region | None | us-east-1 | This is the aws region |
| vpc_id | None | vpc-xxx | This is found under the description of your vpc on the aws console. |
| cluster_name | None | example | Set to the same as the vpc name in the p1 setup. | 
| default_tags | None | None | Leave this blank. |
| private_vpc_cidr | None | 10.0.0.0/16 | This is the IPv4 CIDR for the VPC |
| rhcos_ami | None | ami-abcdef | The RHCOS AMI ID |
| ec2_type | m5.xlarge | m5.xlarge | ec2 instance size, OCP 4 uses the m5.xlarge by default for the control plane creation. | 
| volume_size | 120 | 100 | Default OCP size is 120Gi for volume. |
| cluster_domain | None | example.com | The default domain namespace for the OCP cluster, set in the p1 setup. |
| master_count | 3 | 3| OCP default is set to 3 master nodes. |
|subenet_list | None | subnet-xxx, subnet-xxx, subnet-xxx | These are the subnet ids for the 3 private subnets used for the OCP deployment in the VPC. |
|ssh_public_key | None | rsa public key | A public key to be used for ssh configuration of the registry node |
|rds_postgres_type | db.t2.micro | | This size is sufficient|
|db_size | 20 |  | 20Gi is enough to hold the secrets|
|rds_user| clusteruser | | Change the db user |
|rds_password| changeme | | Make a secure user password | 

## Internet connected box 

As the local user run the following: 
```aidl
git clone https://repo1.dsop.io/dsop/redhat/platformone/ocp4x/terraform/fences $HOME/terraform-fences
tar -cvf terraform-fences.tar.gz $HOME/terraform-fences/
```

## Step 1
On the bastion box with the IAM aws role attached 
```aidl
tar -vxf terraform-fences.tar.gz 
```
- Create a path for terraform to be run locally
```aidl
sudo cp $HOME/fences-terraform/terraform-plugins/bin/terraform /usr/local/bin/
```

## Step 2 
```aidl
chmod +x $HOME/fences-terraform/setup.sh

$HOME/fences-terraform/setup.sh
```

## Step 2.1
Fill out the variables.tf file. The above table has all the needed settings.
```aidl
cd $HOME/fences-terraform/ && vi variables.tf
```
## Step 3 
Create the Security groups
```aidl
cd $HOME/fences-terraform/Security-groups/ && terraform init -plugin-dir="$HOME/.terraform.d/plugin-cache"

cd $HOME/fences-terraform/Security-groups/ && terraform apply -auto-approve 

```
## Step 4 
Create the registry node 
```aidl
cd $HOME/fences-terraform/Registry-node/ && terraform init -plugin-dir="$HOME/.terraform.d/plugin-cache"

cd $HOME/fences-terraform/Registry-node/ && terraform apply -auto-approve 
```

## Step 5
Refer to the OCP4 deploy WIKI to configure the registry.
- [OpenShift 4.x on AWS AirGapped GovCloud](https://repo1.dsop.io/dsop/redhat/platformone/ocp4x/wiki/-/tree/v2-govcloud-automation) 

## Step 6 
Create the internal ELB. 
```aidl
cd $HOME/fences-terraform/elb/ && terraform init -plugin-dir="$HOME/.terraform.d/plugin-cache"

cd $HOME/fences-terraform/elb/ && terraform apply -auto-approve 
```

## Step 7
Create the Control plane. This will create the bootstrap and master nodes as well as attach all 4 IP's to the internal elb created in step 6:
- 1 Bootstrap node in the first subnet variable
- 3 Master nodes with one in each of the subnets
```aidl
cd $HOME/fences-terraform/control-plane/ && terraform init -plugin-dir="$HOME/.terraform.d/plugin-cache"

cd $HOME/fences-terraform/control-plane/ && terraform apply -auto-approve 
```
## Step 8
If the p1 apps are being deployed a postgres database is required. The following modules will create a db-subnetgroup and create a postgres rds database

```aidl
cd $HOME/fences-terraform/rds-db-subnet/ && terraform init -plugin-dir="$HOME/.terraform.d/plugin-cache"

cd $HOME/fences-terraform/rds-db-subnet/ && terraform apply -auto-approve 
```

```aidl
cd $HOME/fences-terraform/postgres-rds/ && terraform init -plugin-dir="$HOME/.terraform.d/plugin-cache"

cd $HOME/fences-terraform/postgres-rds/ && terraform apply -auto-approve 
```

## Destroy created resources 
To destroy the created resources they have to be brought down in the following order:
- Control Plane
- ELB 
- Registry
- Security groups

The command to destroy the resources is terraform destroy
```aidl
cd $HOME/fences-terraform/control-plane && terraform destroy -auto-approve
cd $HOME/fences-terraform/elb/ && terraform destroy -auto-approve
cd $HOME/fences-terraform/Registry-node && terraform destroy -auto-approve
```
If the rds db was created:
```aidl
cd $HOME/fences-terraform/postgres-rds/ && terraform destroy -auto-approve
cd $HOME/fences-terraform/rds-db-subnet/ && terraform destroy -auto-approve
```
The security groups are only destroyed once all other resources have been removed
```aidl
cd $HOME/fences-terraform/Security-groups && terraform destroy -auto-approve
```

