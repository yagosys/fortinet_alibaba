resource "alicloud_route_entry" "spoke_a_default_ack2" {
 depends_on = [alicloud_cen_transit_router_vpc_attachment.atta_ack2]
 route_table_id        = alicloud_vpc.ack2_vpc_default.route_table_id
  destination_cidrblock = var.default_egress_route
  nexthop_type          = "Attachment"
  name                  = "tf-default_to_tr"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.atta_ack2.transit_router_attachment_id
}


