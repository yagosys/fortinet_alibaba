
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

variable "default_egress_route" {
  type    = string
  default = "0.0.0.0/0"
}

variable "cluster_name" {
  type    = string
  default = "FG-AP"
}


variable "instance_ami" {
  type    = string
//  default = "auto"
//  default = "m-t4n4r83t65xn4y88rbk4" //7.0.1 PAGO international 
   default = "m-j6c34y880spxo829x00e" //6.4.5 BYOL China hongkong
}

variable "instance" {
  type = string

  default = "ecs.hfc6.large" //this support 3ENI and ENI hot-plug
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = 2
  memory_size          = 4
  instance_type_family = var.instance //ecs.c5 is default
}



variable "primary_fortigate_private_ip" {

  type    = string
  default = "192.168.11.11"
}


data "alicloud_zones" "default" {
available_instance_type = var.instance
available_resource_creation = "VSwitch"
}

variable "license" {
 default=""
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
variable "account_region" {
  default = "china"
}
