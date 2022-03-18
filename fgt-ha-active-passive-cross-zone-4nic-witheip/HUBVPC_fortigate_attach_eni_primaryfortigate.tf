resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
 depends_on = [alicloud_network_interface.PrimaryFortiGateInterface3,alicloud_instance.PrimaryFortigate]
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1.id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment2" {
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment1]
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface2.id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment3" {
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment2]
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface3.id
}
