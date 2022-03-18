variable "fortiadc_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
   description = "VPC的CIDR"
}

variable "fortiadc_subnet" {
   type = string
   default = "10.0.8.0/21"
}



variable "fortiadc_vswitch_a_cidr_vswitch1_a" {
  type    = string
  default = "10.0.11.0/24"
  description = "第一个可用区的VSWITCH 1 的CIDR"
}

variable "fortiadc_vswitch_a_cidr_vswitch1_a_ip" {
  type = string
  default = "10.0.11.11"
    description = "第一个可用区的VSWITCH里的ENI地址"
}

variable "fortiadc_vswitch_a_cidr_vswitch2_a" {
  type    = string
  default = "10.0.12.0/24"
   description = "第一个可用区的VSWITCH 2的CIDR"
}


variable "fortiadc_cluster_name" {
  type    = string
  default = "fortiadc"
  description = "FORTIGATE的实例名字前缀"
}


variable "fortiadc_instance_ami" {
  type    = string
//  default = "m-uf6brj91pdbswvnbqiwl" //cn-shanghai
//  default = "m-j6c9r4j59vpoqkp4yuv3" //cn-hongkong 6.11
  default = "m-j6ce5v0kaxlyrw1vvoup" //cn-hongkong 7.0
  description = "FortiADC自定义镜像的 image-id"
}

variable "fortiadc_instance" {
  type    = string
//  default = "auto" 
  default= "ecs.hfc6.large"
 description = "FORTIGATE实例的实例类型，默认auto为按照CPU，MEMORY自动选择"
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "fortiadc_types_ds" {
   cpu_core_count       = var.cpu
  memory_size          = var.memory
  system_disk_category = "cloud_efficiency"
  eni_amount = var.instance_type_allowed_eni_amount
  availability_zone  = var.zone_id_1
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


variable fortiadcpublicip_bandwidth_out {
    default = "10"
}

data "alicloud_zones" "fortiadc_zone_default" {
 available_instance_type = data.alicloud_instance_types.fortiadc_types_ds.instance_types.0.id

  available_resource_creation = "VSwitch"
}




