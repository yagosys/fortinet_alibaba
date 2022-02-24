//bind secondary ENI to secondary instances
resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment1" {
  depends_on = [alicloud_instance.SecondaryFortigate,alicloud_network_interface.SecondaryFortiGateInterface3]
  instance_id          = alicloud_instance.SecondaryFortigate.id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface1.id
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment2" {
  depends_on           = [alicloud_network_interface_attachment.SecondaryFortigateattachment1]
  instance_id          = alicloud_instance.SecondaryFortigate.id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface2.id
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment3" {
  depends_on           = [alicloud_network_interface_attachment.SecondaryFortigateattachment2]
  instance_id          = alicloud_instance.SecondaryFortigate.id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface3.id
}
