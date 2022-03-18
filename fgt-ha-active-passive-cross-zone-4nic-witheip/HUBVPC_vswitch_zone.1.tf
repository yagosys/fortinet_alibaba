
resource "alicloud_vswitch" "external_b" {
  vswitch_name = "external_b_1"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_1
  zone_id= data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "internal_b" {
  vswitch_name             = "internal_b_1"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_2
  zone_id= data.alicloud_zones.default.zones.1.id
}


