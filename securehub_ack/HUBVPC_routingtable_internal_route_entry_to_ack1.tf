resource "alicloud_route_entry" "to_ack1" {
  count                 = 1
  depends_on  = [alicloud_cen_transit_router_vpc_attachment.hubvpc,time_sleep.wait_120_seconds]
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.ack1_node_pod_subnet
  nexthop_type          = "Attachment"
  name                  = "tf-to_ack1_vpc_via_tr"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.hubvpc.transit_router_attachment_id
}


