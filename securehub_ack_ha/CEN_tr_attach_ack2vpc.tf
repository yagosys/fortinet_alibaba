resource "alicloud_cen_transit_router_vpc_attachment" "atta_ack2" {
 depends_on =[alicloud_cen_transit_router_vpc_attachment.atta_ack1]
  cen_id            = alicloud_cen_instance.default.id
  transit_router_id = alicloud_cen_transit_router.default.transit_router_id
  vpc_id = alicloud_vpc.ack2_vpc_default.id
 // auto_create_vpc_route=true
  zone_mappings {
//    zone_id = data.alicloud_cen_transit_router_available_resource.default.zones.0.master_zones.0
   zone_id = var.zone_id_1
    vswitch_id = alicloud_vswitch.ack2_vswitch0.id
  }
  zone_mappings {
//    zone_id = data.alicloud_cen_transit_router_available_resource.default.zones.0.slave_zones.0
    zone_id = var.zone_id_2
    vswitch_id = alicloud_vswitch.ack2_vswitch1.id
  }
  transit_router_attachment_name        = "${var.transit_router_attachment_name}-${alicloud_vpc.ack2_vpc_default.name}"
  transit_router_attachment_description = "terraform"

}

resource "alicloud_cen_transit_router_route_table_propagation" "propagte_spoke_a_vpc_route_East-West_rt" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.East-West.transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.atta_ack2.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "associate_spoke_vpc_a_to_tr_rtb_default-North-South" { 
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.default-North-South.transit_router_route_table_id
  transit_router_attachment_id = alicloud_cen_transit_router_vpc_attachment.atta_ack2.transit_router_attachment_id
}


