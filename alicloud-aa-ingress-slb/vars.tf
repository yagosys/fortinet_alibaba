# Access keys can be referenced from the command line via terraform plan -var "access_key=key"
// Configure the Alicloud Provider
variable fgt_internet_max_bandwidth_out {
   type = number
   default = 0
}
variable eip_for_natgw {
   type = number
   default = 0
}

variable slb_private_ip {
   type = string
   default = "172.16.1.50"
}

variable "number_web_vm" {
   type = string
   default = 0
}
variable "license1" {
  type = string
  default = ""
}
variable "license2" {
  type = string
  default = ""
}
variable "licensetype" {
   type = string
   default = "byol"
}
variable "access_key" {
  type    = string
  default = ""
}

variable "secret_key" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "ap-southeast-1" //Default Region
}

variable "vpc_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

variable "vswitch_cidr_1" {
  type    = string
  default = "172.16.0.0/24"
}

variable "vswitch_cidr_2" {
  type    = string
  default = "172.16.8.0/24"
}
variable "vswitch_cidr_interal_ZoneA" {
  type    = string
  default = "172.16.1.0/24"
}
variable "vswitch_cidr_interal_ZoneB" {
  type    = string
  default = "172.16.9.0/24"
}
//Default VPC Egress Route
variable "default_egress_route" {
  type    = string
  default = "0.0.0.0/0"
}
variable "primary_fortigate_private_ip" {
  type    = string
  default = "172.16.0.100"
}
variable "secondary_fortigate_private_ip" {
  type    = string
  default = "172.16.8.100"
}

//If set to true. Creates a custom route table per zone.
//This allows each fortigate to handle egress traffic Indepedently in a healthy state.
variable "split_egress_traffic" {
  type    = string
  default ="no_custom_rtb" 
}

//Retrieves the current account for use with Function Compute
data "alicloud_account" "current" {
}

variable "cluster_name" {
  type    = string
  default = "FortiGateAA-SLB-Sandwidtch"
}

//If an AMI is specified it will be chosen
//Otherwise the ESS config will default to the latest Fortigate version
variable "instance_ami" {
  type    = string
  //default = "m-0xif6xxwhjlqhoaqjrr6"
  default = "m-t4nae88itzcloga8thwz"
}


//Define the instance family to be used.
//Different regions will contain various instance families
//default family : ecs.sn2ne
variable "instance" {
  type    = string
  default = "ecs.c5"
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = 4
  memory_size          = 8
  instance_type_family = var.instance //ecs.g5 is default
}


data "alicloud_images" "ecs_image" {
  owners      = "marketplace"
  most_recent = true
  name_regex  = "^Fortinet FortiGate" // Grab the latest Image from marketplace.
}
