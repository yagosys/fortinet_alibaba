resource "alicloud_vswitch" "ha_ap_unicast_a" {
  name              = "ha_ap_unicast_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_3
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "ha_ap_unicast_b" {
  name              = "ha_ap_unicast_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_3
  availability_zone = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "mgmt_a" {
  name              = "mgmt_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_4
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "mgmt_b" {
  name              = "mgmt_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_4
  availability_zone = data.alicloud_zones.default.zones.1.id
}
