//create eni in order
resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
  name            = "${var.cluster_name}-Primary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${var.activeport2}"
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface2" {
  depends_on      = [alicloud_network_interface.PrimaryFortiGateInterface1]
  name            = "${var.cluster_name}-Primary-HA-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.ha_ap_unicast_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${var.activeport3}"
}
resource "alicloud_network_interface" "PrimaryFortiGateInterface3" {
  depends_on      = [alicloud_network_interface.PrimaryFortiGateInterface2]
  name            = "${var.cluster_name}-Primary-MGMT-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.mgmt_a.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${var.activeport4}"
}
