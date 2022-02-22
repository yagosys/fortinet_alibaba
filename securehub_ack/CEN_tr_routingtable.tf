resource "random_string" "random" {
  length           = 4
  special          = true
  override_special = ""
  min_lower        = 4
}

variable "cen_instance_name" {
  default = "cen-tr0"
}

variable "cen_tr_name" {
  default = "tf"
}



variable "cen_tr_table_name_East-West" {
default = "East-West"
}

variable "cen_tr_table_name_default" {
default = "default-North-South"
}

resource "alicloud_cen_instance" "default" {
  cen_instance_name        = "${var.cen_instance_name}-${random_string.random.result}"
  description = "created by terraform"
}

resource "alicloud_cen_transit_router" "default" {
  transit_router_name       = "${var.cen_tr_name}-${var.cen_region}-${random_string.random.result}"
  cen_id     = alicloud_cen_instance.default.id
}


variable "transit_router_attachment_name" {
  default = "ATTA"
}

resource "alicloud_cen_transit_router_route_table" "default-North-South" {
  transit_router_id = alicloud_cen_transit_router.default.transit_router_id
  transit_router_route_table_name="${var.cen_tr_name}-${var.cen_tr_table_name_default}"
}

resource "alicloud_cen_transit_router_route_table" "East-West" {
  transit_router_id = alicloud_cen_transit_router.default.transit_router_id
  transit_router_route_table_name="${var.cen_tr_name}-${var.cen_tr_table_name_East-West}"
}


