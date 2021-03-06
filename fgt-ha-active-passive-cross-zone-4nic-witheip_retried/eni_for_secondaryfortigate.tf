//secondary ENI for secondaryfortigate and bind to switch in zone b
resource "alicloud_network_interface" "SecondaryFortiGateInterface1" {
  name            = "${var.cluster_name}-Secondary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_b.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${var.passiveport2}"
}
//Third ENI for secondaryFortigate
resource "alicloud_network_interface" "SecondaryFortiGateInterface2" {
  depends_on      = [alicloud_network_interface.SecondaryFortiGateInterface1]
  name            = "${var.cluster_name}-Secondary-HA-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.ha_ap_unicast_b.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${var.passiveport3}"
}
//Forth ENI for secondaryFortigate
resource "alicloud_network_interface" "SecondaryFortiGateInterface3" {
  depends_on      = [alicloud_network_interface.SecondaryFortiGateInterface2]
  name            = "${var.cluster_name}-Secondary-MGMT-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.mgmt_b.id
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
  private_ip      = "${var.passiveport4}"
}
