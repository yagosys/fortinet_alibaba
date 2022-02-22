data "alicloud_instance_types" "ack1_default" {
  cpu_core_count = "${var.cpu_core_count}"
  memory_size    = "${var.memory_size}"
}

resource "alicloud_vpc" "ack1_vpc_default" {
  vpc_name = var.example_name_ack1
  cidr_block = var.ack1_vpc_cidr 
}

resource "alicloud_vswitch" "ack1_vswitch0" {
  vswitch_name = "${var.example_name_ack1}-0"
  vpc_id = alicloud_vpc.ack1_vpc_default.id
  cidr_block = var.ack1_vswitch0_subnet
//  zone_id = data.alicloud_zones.default.zones[0].id
   zone_id = var.zone_id_1
}

resource "alicloud_vswitch" "ack1_vswitch1" {
  vswitch_name = "${var.example_name_ack1}-1"
  vpc_id = alicloud_vpc.ack1_vpc_default.id
  cidr_block = var.ack1_vswitch1_subnet
 // zone_id = data.alicloud_zones.default.zones[1].id
  zone_id = var.zone_id_2
}
