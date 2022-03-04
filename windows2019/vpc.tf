resource "random_string" "psk" {
  length           = 16
  special          = true
  override_special = ""
}

resource "random_string" "random_name_post" {
  length           = 4
  special          = true
  override_special = ""
  min_lower        = 4
}


resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  vpc_name   = "${var.instance_name}-${random_string.random_name_post.result}"
}


resource "alicloud_vswitch" "vswitch1_a" {
  vswitch_name = "internal_a"
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_a_cidr_vswitch1_a
  zone_id      = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "vswitch2_a" {
  vswitch_name = "internal_a"
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_a_cidr_vswitch2_a
  zone_id      = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "vswitch3_a" {
  vswitch_name = "internal_a"
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_a_cidr_vswitch3_a
  zone_id      = data.alicloud_zones.default.zones.0.id
}



