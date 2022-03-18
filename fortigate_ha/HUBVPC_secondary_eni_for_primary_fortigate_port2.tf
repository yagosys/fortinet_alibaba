resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
 depends_on = [alicloud_vswitch.internal_a_0,time_sleep.wait_60_seconds_after_create_internal_a_vswitch]
  network_interface_name = "${var.cluster_name}-Primary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_a_0.id
  security_group_ids = ["${alicloud_security_group.SecGroup.id}"]
  primary_ip_address      = var.primary_fortigate_secondary_private_ip
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface2" {
  depends_on      = [alicloud_network_interface.PrimaryFortiGateInterface1]
  name            = "${var.cluster_name}-Primary-HA-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.ha_ap_unicast_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${local.activeport3}"
}
resource "alicloud_network_interface" "PrimaryFortiGateInterface3" {
  depends_on      = [alicloud_network_interface.PrimaryFortiGateInterface2]
  name            = "${var.cluster_name}-Primary-MGMT-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.mgmt_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${local.activeport4}"
}
