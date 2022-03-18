variable "fortigate_instance_ami" {
  type    = string
 // default = "auto"
  default = "m-j6cb70hq53jfyxses1vu"
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = var.cpu_core_count
  memory_size          = var.memory_size
  eni_amount = var.eni_amount
}

variable "product" {
   type = string
//   default = "Fortinet FortiGate (BYOL) Next-Generation Firewall"
   default = "FortiGate-6.4.5.+BYOL"
}

data "alicloud_images" "ecs_image" {
  count = var.fortigate_instance_ami=="auto"? 1:0
  owners = "marketplace"
  most_recent = true
  name_regex = var.product
}

variable "eip" {
  default = "1"
}
variable "mgmt_eip" {
  default = "1"
}

variable "num_secondary_instances" {
default = "1"
}

variable "custom_rt" {
default = "1"
}

variable  "cpu_core_count" {
 default= "4"
}
variable "memory_size" {
 default = "8"
}

variable "eni_amount" {
 default = "3"
}
