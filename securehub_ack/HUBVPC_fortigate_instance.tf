resource "alicloud_instance" "PrimaryFortigate" {

 availability_zone = "${data.alicloud_zones.default.zones.0.id}"
 image_id = "${length(var.fortigate_instance_ami) > 5 ? var.fortigate_instance_ami : data.alicloud_images.ecs_image.images.0.id}"
  security_groups   = "${alicloud_security_group.SecGroup.*.id}"
  user_data            = data.template_file.activeFortiGate.rendered
  instance_type = "${data.alicloud_instance_types.types_ds.instance_type_family}"
  internet_max_bandwidth_out = 100
  instance_name        = "${var.cluster_name}-Primary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id           = "${alicloud_vswitch.external_a_0.id}"
  private_ip           = "${var.primary_fortigate_private_ip}"
  tags = {
    Name = "FortiGate-Terraform"
  }
    data_disks {
    size                 = 30
  //  category             = "cloud_essd"
    delete_with_instance = true
  }
  
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
  instance_id          = alicloud_instance.PrimaryFortigate.id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1.id
}


