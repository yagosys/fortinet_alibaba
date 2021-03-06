# Access keys can be referenced from the command line via terraform plan -var "access_key=key"
# Configure the Alicloud Provider

variable "ossBucketName" {
    type = string
    default = ""
}

variable "access_key"{
    type = string
    default = ""
}
variable "secret_key"{
    type = string
    default = ""
}
variable "region" {
    type = string
    default = "" //Default Region
}
variable "vpc_cidr"{
    type = string
    default = "172.16.0.0/16"
}

variable "vswitch_cidr_1"{
    type = string
    default = "172.16.0.0/21"
}
variable "vswitch_cidr_2"{
    type = string
    default = "172.16.8.0/21"
}

//CPU threshold to scale in or out
variable "scale_in_threshold"{
    type = string
    default = 35
}
variable "scale_out_threshold"{
    type = string
    default = 70
}
//Retrieves the current account for use with Function Compute
data "alicloud_account" "current"{
}

variable "cluster_name"{
    type = string
    default = "FortigateAutoScale"
}

//OSS Bucket Name MUST be lowercase
variable "bucket_name"{
    type = string
    default = "fortigateautoscale"
}
//If an AMI is specified it will be chosen
//Otherwise the ESS config will default to the latest Fortigate version
variable "instance_ami" {
    type = string
    default = "m-0xif6xxwhjlqhoaqjrr6"
}

//Define the instance family to be used.
//Different regions will contain various instance families
//default family : ecs.sn2ne
variable "instance" {
    type = string
    default = "ecs.c5"
}
//Specify the TableStore instance type - This is regionaly dependent
//See the following for supported regions:
//https://www.alibabacloud.com/help/doc-detail/52664.htm?spm=a2c63.p38356.b99.7.b1c01166CECQUC
variable "table_store_instance_type" {
    type = string
    default = "Capacity" //Must be HighPerformance or Capacity
}


//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
    cpu_core_count = 2
    memory_size = 4
    instance_type_family = "${var.instance}" //ecs.g5 is default
}

data "alicloud_images" "ecs_image" {
    owners = "marketplace"
    most_recent = true
    name_regex  = "^Fortinet FortiGate"// Grab the latest Image from marketplace.
}
