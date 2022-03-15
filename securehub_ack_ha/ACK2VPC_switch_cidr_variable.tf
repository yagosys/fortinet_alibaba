data "alicloud_instance_types" "ack2_default" {
  cpu_core_count = "${var.cpu_core_count}"
  memory_size    = "${var.memory_size}"
}

resource "alicloud_vpc" "ack2_vpc_default" {
  vpc_name = var.example_name_ack2
  cidr_block = var.ack2_vpc_cidr 
}

resource "alicloud_vswitch" "ack2_vswitch0" {
  vswitch_name = "${var.example_name_ack2}-0"
  vpc_id = alicloud_vpc.ack2_vpc_default.id
  cidr_block = var.ack2_vswitch0_subnet
//  zone_id = data.alicloud_zones.default.zones[0].id
   zone_id = var.zone_id_1
}

resource "alicloud_vswitch" "ack2_vswitch1" {
  vswitch_name = "${var.example_name_ack2}-1"
  vpc_id = alicloud_vpc.ack2_vpc_default.id
  cidr_block = var.ack2_vswitch1_subnet
 // zone_id = data.alicloud_zones.default.zones[1].id
  zone_id = var.zone_id_2
}
