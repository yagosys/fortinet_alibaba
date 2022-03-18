variable "tr_landing_route_entry" {
  default = "0.0.0.0/0"
}

resource "alicloud_route_table" "tr_landing_rt" {
  depends_on  = [time_sleep.wait_120_seconds,alicloud_vpc.vpc]
  count       = 1
  vpc_id      = alicloud_vpc.vpc.id
  route_table_name        = "Tr-landing-${random_string.random_name_post.result}-${count.index}"
  description = "TR-landing routing table"
}

resource "alicloud_route_table_attachment" "tr_landing_attachment" {
  //  depends_on = [alicloud_route_table_attachment.custom_route_table_attachment_private_zoneb]
  depends_on = [time_sleep.wait_60_seconds_after_create_custom_rt]
  count          = 1
  vswitch_id     = alicloud_vswitch.landing_for_cen_a_0.id
  route_table_id = alicloud_route_table.tr_landing_rt[count.index].id
}

resource "alicloud_route_table_attachment" "tr_landing_attachment_1" {
  depends_on = [alicloud_route_table_attachment.tr_landing_attachment]
  count          = 1
  vswitch_id     = alicloud_vswitch.landing_for_cen_b_1.id
  route_table_id = alicloud_route_table.tr_landing_rt[count.index].id
}


