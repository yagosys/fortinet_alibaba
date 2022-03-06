variable "activelicense" {
  default = ""
}

variable "activeconfig" {
  default = ""
}

variable "passivelicense" {
 default=""
}

variable "passiveconfig" {
 default = ""
}
variable "license_type" {
 default = "byol"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/8"
   description = "VPC的CIDR"
}


variable "vswitch_a_cidr_vswitch1_a" {
  type    = string
  default = "10.0.11.0/24"
  description = "第一个可用区的VSWITCH 1 的CIDR"
}

variable "vswitch_a_cidr_vswitch1_a_ip" {
  type = list(string)
  default = ["10.0.11.11","10.0.11.12","10.0.11.13","10.0.11.14"]
    description = "第一个可用区的VSWITCH里的ENI地址"
}

variable "vswitch_a_cidr_vswitch2_a" {
  type    = string
  default = "10.0.12.0/24"
   description = "第一个可用区的VSWITCH 2的CIDR"
}

variable "vswitch_a_cidr_vswitch3_a" {
  type    = string
  default = "10.0.13.0/24"
   description = "第一个可用区的VSWITCH 3的CIDR"
}



variable "cluster_name" {
  type    = string
  default = "forti"
  description = "FORTIGATE的实例名字前缀"
}


variable "instance_ami" {
  type    = string
  default = "m-j6cci77g4mwuaa8xfkx7"
  description = "FortiADC自定义镜像的 image-id"
}

variable "instance" {
  type    = string
  default = "auto" 
//  default="ecs.ic5.large"
 description = "FORTIGATE实例的实例类型，默认auto为按照CPU，MEMORY自动选择"
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
   cpu_core_count       = var.cpu
  memory_size          = var.memory
  system_disk_category = "cloud_efficiency"
  eni_amount = var.instance_type_allowed_eni_amount
 // instance_type_family = var.instance //ecs.c5 is default
}

variable instance_type_allowed_eni_amount {
 default=3
  description = "FORTIGATE实例的实例类型的网卡数量"
 }
variable cpu {
 default=4
  description = "FORTIGATE实例的实例类型的CPU核心数"
 }
 
variable memory {
  default =8
    description = "FORTIGATE实例的实例类型的内存数量，单位为G "
}



data "alicloud_zones" "default" {
 available_instance_type = data.alicloud_instance_types.types_ds.instance_types.0.id
//  available_instance_type = var.instance

  available_resource_creation = "VSwitch"
}




