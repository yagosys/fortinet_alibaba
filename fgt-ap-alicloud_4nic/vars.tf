data "alicloud_zones" "default_sn1ne" {
 available_instance_type = var.instance !="auto" ? var.instance : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.sn1ne.2xlarge"], instance))],["ecs.hfc6.4xlarge"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_hfc6" {
 available_instance_type = var.instance !="auto" ? var.instance : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.hfc6.2xlarge"], instance))],["ecs.hfc6.4xlarge"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_c5" {
 available_instance_type = var.instance !="auto" ? var.instance : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.c5.2xlarge"], instance))],["ecs.hfc6.4xlarge"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_hfc5" {
 available_instance_type = var.instance !="auto" ? var.instance : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.hfc5.2xlarge"], instance))],["ecs.hfc6.4xlarge"]),0)
 available_resource_creation = "VSwitch"
}

variable "iam" {

  default = "Terraform-Fortigate-HA-New"
}
variable "account_region" {
  default = "international"
}

variable "region" {
  type    = string
  default = "cn-hongkong" //Default Region
}


variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "vswitch_a_cidr_1" {
  type    = string
  default = "192.168.11.0/24"
}

variable "vswitch_a_cidr_2" {
  type    = string
  default = "192.168.12.0/24"
}

variable "vswitch_a_cidr_3" {
  type    = string
  default = "192.168.13.0/24"
}

variable "vswitch_a_cidr_4" {
  type    = string
  default = "192.168.14.0/24"
}

variable "vswitch_b_cidr_1" {
  type    = string
  default = "192.168.21.0/24"
}

variable "vswitch_b_cidr_2" {
  type    = string
  default = "192.168.22.0/24"
}

variable "vswitch_b_cidr_3" {
  type    = string
  default = "192.168.23.0/24"
}

variable "vswitch_b_cidr_4" {
  type    = string
  default = "192.168.24.0/24"
}

variable "default_egress_route" {
  type    = string
  default = "0.0.0.0/0"
}

variable "cluster_name" {
  type    = string
  default = "FG-AP"
}

// Configure the Alicloud Provider


variable "instance_ami" {
  type    = string
  default = "auto"
}

variable "instance" {
  type = string

  default = "ecs.hfc6.2xlarge" //this is 8Core16G
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = 8
  memory_size          = 16
  instance_type_family = var.instance //ecs.hfc6 is default
}


data "alicloud_zones" "default" {
  available_instance_type     = var.instance
  available_resource_creation = "VSwitch"
}

//data "alicloud_account" "current" {
//}




variable "primary_fortigate_private_ip" {

  type    = string
  default = "192.168.11.11"
}



//for SecondaryFortigate

variable "secondary_fortigate_private_ip" {
  type    = string
  default = "192.168.21.12"
}


variable "product_intl" {
   type = string
//   default = "^Fortinet FortiGate-6.4.5"
default = "^Fortinet FortiGate .*\\(8 vCPUs.*.+7.0.+2"
}

variable "product_china" {
  type = string
  default = "^Fortinet FortiGate-6.4.5"
}

data "alicloud_images" "ecs_image" {
  owners      = "marketplace"
  //name_regex  = "^Fortinet FortiGate-6.4.5" // Grab the latest Image from marketplace.
  name_regex = var.account_region=="china" ? var.product_china : var.product_intl
}

variable "license1" {
 default=""
}

variable "license2" {
 default=""
}
