// VPC ID
variable "vpc_id" { default = "" }
variable "private_vpc_cidr" {default = "" }


// CIDR Blocks
variable "cidr_blocks" { default = "" }

// VPC NAME
variable "vpc_name" { default = "" }

// Rhcos AMI ID
variable "rhcos_ami" { default = "" }

// Target Environment
variable "target_environment" { default = "" }

// Cluster name "sparta"
variable "cluster_name" { default = "" }

// Domain name, "example.com"
variable "cluster_domain" { default = "" }

// Name domain, "sparta.example.com"
variable "name_domain" { default = "" }

// Private subnet List
variable "subnet_list" {
  description = "AWS Private Subnets"
  type = list(string)
  default = [""]
}

// Default ec2 properties per RedHat offical minimum requirements
variable "ec2_type" { default = "m5.xlarge" }
variable "volume_size" { default = "120" }
variable "default_tags" { default = {} }
variable "master_count" { default = "3" }


// Leave empty, secrets are configured via the setup ansible tasks
variable "aws_access_key" { default = "" }
variable "aws_access_key_id" { default = "" }
variable "aws_secret_key" { default = "" }
variable "aws_secret_access_key" { default = "" }
variable "aws_region" { default = "" }
