variable "fortigate_instance_ami" {
  type    = string
 // default = "auto"
  default = "m-j6cb70hq53jfyxses1vu"
}

//Get Instance types with min requirements in the region.
//If left with no instance_type_family the return may include shared instances.
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = 1
  memory_size          = 2
  instance_type_family = var.instance //ecs.c5 is default
}

variable "product" {
   type = string
   default = "Fortinet FortiGate (BYOL) Next-Generation Firewall"
//   default = "FortiGate-6.4.5.+BYOL"
}

data "alicloud_images" "ecs_image" {
  owners = "marketplace"
  most_recent = true
  name_regex = var.product
}

