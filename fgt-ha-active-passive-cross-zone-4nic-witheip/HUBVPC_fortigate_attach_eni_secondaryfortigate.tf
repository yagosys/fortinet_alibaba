resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment1" {
  count=var.num_secondary_instances
  instance_id          = alicloud_instance.SecondaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface1.id
}


resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment2" {
  count=var.num_secondary_instances
  depends_on           = [alicloud_network_interface_attachment.SecondaryFortigateattachment1]
  instance_id          = alicloud_instance.SecondaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface2.id
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateattachment3" {
  count=var.num_secondary_instances
  depends_on           = [alicloud_network_interface_attachment.SecondaryFortigateattachment2]
  instance_id          = alicloud_instance.SecondaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.SecondaryFortiGateInterface3.id
}

