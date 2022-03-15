//data "alicloud_cen_transit_router_available_resource" "default" {
//}

//variable "transit_router_attachment_name" {
 // default = "tr-atta-hubvpc"
//}

resource "alicloud_cen_transit_router_vpc_attachment" "hubvpc" {
// depends_on =[alicloud_cen_transit_router.default,alicloud_vpc.vpc,time_sleep.wait_600_seconds]
 depends_on =[alicloud_cen_transit_router.default,alicloud_vpc.vpc,time_sleep.wait_360_seconds]
  cen_id            = alicloud_cen_instance.default.id
  transit_router_id = alicloud_cen_transit_router.default.transit_router_id
  vpc_id = alicloud_vpc.vpc.id
  zone_mappings {
//    zone_id = data.alicloud_cen_transit_router_available_resource.default.zones.0.master_zones.0
   zone_id = var.zone_id_1
    vswitch_id = alicloud_vswitch.landing_for_cen_a_0.id
  }
  zone_mappings {
//    zone_id = data.alicloud_cen_transit_router_available_resource.default.zones.0.slave_zones.0
    zone_id = var.zone_id_2
    vswitch_id = alicloud_vswitch.landing_for_cen_b_1.id
  }
  transit_router_attachment_name        = "${var.transit_router_attachment_name}-${alicloud_vpc.vpc.name}"
  transit_router_attachment_description = "terraform"

}


resource "alicloud_cen_transit_router_route_table_propagation" "default_for_hubvpc_East-West" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.East-West.transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.hubvpc.transit_router_attachment_id
}


resource "alicloud_cen_transit_router_route_table_association" "default_hub_vpc" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.East-West.transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.hubvpc.transit_router_attachment_id
}


variable "rt_default" {
  default = "0.0.0.0/0"
}
// for config a default route to tr hub-vpc on tf-default for spoke vpc to use
resource "alicloud_cen_transit_router_route_entry" "tr_cen_tf_default_router_entry" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.default-North-South.transit_router_route_table_id
  transit_router_route_entry_destination_cidr_block = var.rt_default
  transit_router_route_entry_next_hop_type = "Attachment"
  transit_router_route_entry_name = "terraform-tf-default-0.0.0.0"
  transit_router_route_entry_description = "terraform-tf-default-0.0.0.0"
  transit_router_route_entry_next_hop_id = alicloud_cen_transit_router_vpc_attachment.hubvpc.transit_router_attachment_id
}
