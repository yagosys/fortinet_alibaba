variable "vswitch_cidr_ha_zoneA" {
   type  = string
   default = "172.16.13.0/24"
}

variable "vswitch_cidr_ha_zoneB" {
   default = "172.16.23.0/24"
}

resource "alicloud_vswitch" "vsw_ha_A" {
   vpc_id = alicloud_vpc.vpc.id
   cidr_block = var.vswitch_cidr_ha_zoneA
   availability_zone = data.alicloud_zones.default.zones[0].id
}

resource "alicloud_vswitch" "vsw_ha_B" {
   vpc_id = alicloud_vpc.vpc.id
   cidr_block =var.vswitch_cidr_ha_zoneB
   availability_zone = data.alicloud_zones.default.zones[1].id
}
resource "alicloud_network_interface" "PrimaryFortiGateInterfaceHa" {
   depends_on  = [alicloud_network_interface_attachment.PrimaryFortigateattachment]
   name = "${var.cluster_name}-PrimaryPrivateENI-HA-${random_string.random_name_post.result}"
   vswitch_id = "${alicloud_vswitch.vsw_ha_A.id}"
   private_ip = "172.16.13.100"
   security_groups = ["${alicloud_security_group.SecGroup.id}"]
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateInterfaceHaattachment" {
   instance_id = "${alicloud_instance.PrimaryFortigate.id}"
   network_interface_id = "${alicloud_network_interface.PrimaryFortiGateInterfaceHa.id}"
}

resource "alicloud_network_interface" "SecondaryFortigateInterfaceHa" {
   depends_on  = [alicloud_network_interface_attachment.SecondaryFortigateAttachment]
  name = "${var.cluster_name}-SecondaryPrivateENI-HA${random_string.random_name_post.result}"
  vswitch_id = "${alicloud_vswitch.vsw_ha_B.id}"
  private_ip = "172.16.23.100"
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateHaAttachment" {
  instance_id = "${alicloud_instance.SecondaryFortigate.id}"
  network_interface_id = "${alicloud_network_interface.SecondaryFortigateInterfaceHa.id}"
}
