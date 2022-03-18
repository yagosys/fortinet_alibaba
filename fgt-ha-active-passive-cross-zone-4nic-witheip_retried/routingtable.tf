variable "custom_route_table_count" {
  type    = number
  default = 1

}
//default for primary fortigate, default route for internal network is torwars primary fortigate secondary inteface (primaryFortigateInterface1)
resource "alicloud_route_table" "custom_route_tables" {
  depends_on  = [time_sleep.wait_120_seconds]
  count       = 1
  vpc_id      = alicloud_vpc.vpc.id
  name        = "${var.cluster_name}-FortiGateEgress-${random_string.random_name_post.result}-${count.index}"
  description = "FortiGate Egress route tables, created with terraform."
}





resource "alicloud_route_entry" "custom_route_table_egress" {
  depends_on            = [alicloud_network_interface.PrimaryFortiGateInterface1]
  count                 = 1
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.default_egress_route //Default is 0.0.0.0/0
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1.id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1.id
}
resource "alicloud_route_table_attachment" "custom_route_table_attachment_private" {
  count          = 1
  vswitch_id     = alicloud_vswitch.internal_a.id
  route_table_id = alicloud_route_table.custom_route_tables[count.index].id
}
