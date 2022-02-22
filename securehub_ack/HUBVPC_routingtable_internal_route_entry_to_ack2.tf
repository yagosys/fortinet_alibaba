resource "alicloud_route_entry" "to_ack2" {
  count                 = 1
  depends_on  = [alicloud_cen_transit_router_vpc_attachment.hubvpc,time_sleep.wait_120_seconds]
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.ack2_node_pod_subnet
  nexthop_type          = "Attachment"
  name                  = "tf-to_ack2_vpc_via_tr"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.hubvpc.transit_router_attachment_id
}


