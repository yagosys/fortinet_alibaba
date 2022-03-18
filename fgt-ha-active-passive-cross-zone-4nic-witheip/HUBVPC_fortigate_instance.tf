resource "alicloud_instance" "PrimaryFortigate" {

 availability_zone = "${data.alicloud_zones.default.zones.0.id}"
 image_id = "${length(var.fortigate_instance_ami) > 5 ? var.fortigate_instance_ami : data.alicloud_images.ecs_image[0].images.0.id}"
  security_groups   = "${alicloud_security_group.SecGroup.*.id}"
  user_data            = data.template_file.activeFortiGate.rendered

 instance_type = coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")

  internet_max_bandwidth_out= var.eip =="0" ? 100 : 0
  instance_name        = "${var.cluster_name}-Primary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id           = "${alicloud_vswitch.external_a_0.id}"
  private_ip           = "${var.primary_fortigate_private_ip}"
  role_name     = var.iam !="Fortigate-HA-New" ? alicloud_ram_role.role[0].id : var.iam
  tags = {
    Name = "FGT1"
  }
    data_disks {
    size                 = 30
    delete_with_instance = true
  }
  
}


resource "alicloud_instance" "SecondaryFortigate" {
  count=var.num_secondary_instances
  availability_zone = data.alicloud_zones.default.zones.1.id
  security_groups   = alicloud_security_group.SecGroup.*.id

 image_id = "${length(var.fortigate_instance_ami) > 5 ? var.fortigate_instance_ami : data.alicloud_images.ecs_image[0].images.0.id}"


  user_data     = data.template_file.passiveFortiGate.rendered
 instance_type = coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")

  internet_max_bandwidth_out= var.eip =="0" ? 100 : 0
  instance_name = "${var.cluster_name}-Secondary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id    = alicloud_vswitch.external_b.id
  private_ip    = var.secondary_fortigate_private_ip
  role_name     = var.iam !="Fortigate-HA-New" ? alicloud_ram_role.role[0].id : var.iam
  tags = {
    Name = "FGT2"
  }
  data_disks {
    size                 = 30
    category             = "cloud_essd"
    delete_with_instance = true
  }
}
