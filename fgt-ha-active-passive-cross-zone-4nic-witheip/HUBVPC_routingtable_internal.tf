//default for primary fortigate, default route for internal network is torwars primary fortigate secondary inteface (primaryFortigateInterface1)
resource "alicloud_route_table" "custom_route_tables" {
  count       = var.custom_rt=="1" ? 1 : 0
  vpc_id      = alicloud_vpc.vpc.id
  route_table_name        = "${var.cluster_name}-internal_fortigate_port2-${random_string.random_name_post.result}-${count.index}"
  description = "hubvpc internal route tables, nexthop to fortigate port 2-eni created with terraform."
}

resource "alicloud_route_table_attachment" "custom_route_table_attachment_private" {
  count       = var.custom_rt=="1" ? 1 : 0
  depends_on = [alicloud_route_table.custom_route_tables]
  vswitch_id     = alicloud_vswitch.internal_a_0.id
  route_table_id = alicloud_route_table.custom_route_tables[count.index].id
}

resource "alicloud_route_table_attachment" "custom_route_table_attachment_private_zoneb" {
  count       = var.custom_rt=="1" ? 1 : 0
  depends_on = [alicloud_route_table_attachment.custom_route_table_attachment_private]
  vswitch_id     = alicloud_vswitch.internal_b.id
  route_table_id = alicloud_route_table.custom_route_tables[count.index].id
}
