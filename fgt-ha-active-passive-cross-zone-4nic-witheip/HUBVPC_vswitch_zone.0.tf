
resource "alicloud_vswitch" "external_a_0" {
  vswitch_name              = "external_a_0"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_1
  zone_id = "${data.alicloud_zones.default.zones.0.id}"
}

resource "alicloud_vswitch" "internal_a_0" {
  vswitch_name              = "internal_a_0"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_2
  zone_id = "${data.alicloud_zones.default.zones.0.id}"
}

