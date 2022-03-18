variable "instance" {
 default = "auto"
}

data "alicloud_instance_types" "types_ds" {
  cpu_core_count       =  8
  memory_size          =  16
  eni_amount = 4
}

data "alicloud_zones" "default_c5" {
 available_instance_type = var.instance !="auto" ? var.instance : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.c5.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
