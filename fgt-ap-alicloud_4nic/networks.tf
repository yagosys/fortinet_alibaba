resource "alicloud_vswitch" "external_a" {
  name              = "external_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_1
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "internal_a" {
  name              = "internal_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_2
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "ha_ap_unicast_a" {
  name              = "ha_ap_unicast_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_3
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "mgmt_a" {
  name              = "mgmt_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_4
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "external_b" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_1
  availability_zone = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "internal_b" {
  name              = "internal_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_2
  availability_zone = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "ha_ap_unicast_b" {
  name              = "ha_ap_unicast_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_3
  availability_zone = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "mgmt_b" {
  name              = "mgmt_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_4
  availability_zone = data.alicloud_zones.default.zones.1.id
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [alicloud_vswitch.internal_a]

  create_duration = "120s"
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [alicloud_route_table.custom_route_tables]

  create_duration = "60s"
}
