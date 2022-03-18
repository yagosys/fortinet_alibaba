resource "alicloud_route_entry" "tr_landing_rt_default_route_to_eni" {
  count                 = 1
  depends_on = [alicloud_route_entry.internal_rt_default_route_to_eni]
  //depends_on  = [time_sleep.wait_60_seconds_after_create_custom_rt]
  route_table_id        = alicloud_route_table.tr_landing_rt[count.index].id
  destination_cidrblock = var.tr_landing_route_entry
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1.id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1.id
}

