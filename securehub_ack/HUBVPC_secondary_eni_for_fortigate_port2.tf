resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
  network_interface_name = "${var.cluster_name}-Primary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_a_0.id
  security_group_ids = ["${alicloud_security_group.SecGroup.id}"]
  primary_ip_address      = var.primary_fortigate_secondary_private_ip
}


