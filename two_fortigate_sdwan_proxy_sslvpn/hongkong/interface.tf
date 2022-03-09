resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
  depends_on = [alicloud_instance.PrimaryFortigate]
  network_interface_name = "${var.cluster_name}-Primary-Internal-ENI-${random_string.random_name_post.result}"
  vswitch_id      = alicloud_vswitch.internal_a.id
  security_group_ids = ["${alicloud_security_group.SecGroup.id}"]
  primary_ip_address      = "${var.activeport2}"
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
  depends_on = [alicloud_network_interface.PrimaryFortiGateInterface1]
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1.id
}
