resource "random_string" "psk" {
  length           = 16
  special          = true
  override_special = ""
}

resource "random_string" "random_name_post" {
  length           = 4
  special          = true
  override_special = ""
  min_lower        = 4
}


resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  vpc_name       = "${var.cluster_name}-${random_string.random_name_post.result}"
}

variable "custom_route_table_count" {
  type    = number
  default = 1

}

resource "alicloud_vswitch" "external_a" {
  vswitch_name              = "external_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_1
#availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  zone_id = "${data.alicloud_zones.default.zones.0.id}"
}

resource "alicloud_vswitch" "internal_a" {
  vswitch_name              = "internal_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_2
#availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  zone_id = "${data.alicloud_zones.default.zones.0.id}"
}




resource "alicloud_instance" "PrimaryFortigate" {

 availability_zone = "${data.alicloud_zones.default.zones.0.id}"
 image_id = "${length(var.instance_ami) > 5 ? var.instance_ami : data.alicloud_images.ecs_image.images.0.id}"
  security_groups   = "${alicloud_security_group.SecGroup.*.id}"
  user_data            = data.template_file.activeFortiGate.rendered
  instance_type = "${data.alicloud_instance_types.types_ds.instance_type_family}"
  internet_max_bandwidth_out = 10
  instance_name        = "${var.cluster_name}-Primary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id           = "${alicloud_vswitch.external_a.id}"
  private_ip           = "${var.primary_fortigate_private_ip}"
  tags = {
    Name = "FortiGate-Terraform"
  }
}


