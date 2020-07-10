#!/usr/bin/env bash

mkdir -p $HOME/.terraform.d/plugin-cache
cp $HOME/fences-terraform/terraform-plugins/plugins/terraform-provider-aws_v2.68.0_x4 $HOME/.terraform.d/plugin-cache

ln -s $HOME/fences-terraform/provider.tf $HOME/fences-terraform/control-plane
ln -s $HOME/fences-terraform/provider.tf $HOME/fences-terraform/elb
ln -s $HOME/fences-terraform/provider.tf $HOME/fences-terraform/Registry-node
ln -s $HOME/fences-terraform/provider.tf $HOME/fences-terraform/Security-groups
ln -s $HOME/fences-terraform/provider.tf $HOME/fences-terraform/postgres-rds
ln -s $HOME/fences-terraform/provider.tf $HOME/fences-terraform/rds-db-subnet

ln -s $HOME/fences-terraform/variables.tf $HOME/fences-terraform/control-plane
ln -s $HOME/fences-terraform/variables.tf $HOME/fences-terraform/elb
ln -s $HOME/fences-terraform/variables.tf $HOME/fences-terraform/Registry-node
ln -s $HOME/fences-terraform/variables.tf $HOME/fences-terraform/Security-groups
ln -s $HOME/fences-terraform/variables.tf $HOME/fences-terraform/postgres-rds
ln -s $HOME/fences-terraform/variables.tf $HOME/fences-terraform/rds-db-subnet
