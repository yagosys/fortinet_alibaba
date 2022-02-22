resource "alicloud_route_entry" "spoke_vpc_default_route" {
  count                 = 1
  depends_on  = [time_sleep.wait_60_seconds]
  route_table_id        = alicloud_route_table.tr_landing_rt[count.index].id
  destination_cidrblock = var.tr_landing_route_entry //Default is 0.0.0.0/0
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1.id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1.id
}

