resource "alicloud_route_entry" "fortiadc_vpc_default" {
 depends_on = [alicloud_cen_transit_router_vpc_attachment.atta_fortiadc]
 route_table_id        = alicloud_vpc.fortiadc_vpc.route_table_id
  destination_cidrblock = var.default_egress_route
  nexthop_type          = "Attachment"
  name                  = "tf-default_to_tr"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.atta_fortiadc.transit_router_attachment_id
}


