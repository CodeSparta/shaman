variable "aws_region" { default = "" }
variable "vpc_id" { default = "" }
variable "cluster_name" { default = "" }
variable "cluster_domain" { default = "" }
variable "private_vpc_cidr" {default = "" }
variable "rhcos_ami" { default = "" }
variable "aws_access_key" { default = "" }
variable "aws_secret_key" { default = "" }

variable "ec2_type" { default = "m5.xlarge" }
variable "volume_size" { default = "120" }
variable "default_tags" { default = {} }
variable "master_count" { default = "3" }

variable "subnet_list" {
  description = "AWS Private Subnets"
  type = list(string)
  default = ["" , "" , "" ]
}
variable "ssh_public_key" {
  default = ""
}

