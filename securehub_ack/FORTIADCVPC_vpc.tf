

resource "alicloud_vpc" "fortiadc_vpc" {
  cidr_block = var.fortiadc_vpc_cidr
  vpc_name   = "${var.fortiadc_cluster_name}-${random_string.random_name_post.result}"
}


resource "alicloud_vswitch" "fortiadc_vswitch1_a" {
  vswitch_name = "fortiadc_vswitch1_internal_a"
  vpc_id       = alicloud_vpc.fortiadc_vpc.id
  cidr_block   = var.fortiadc_vswitch_a_cidr_vswitch1_a
  zone_id      = var.zone_id_1
}

resource "alicloud_vswitch" "fortiadc_vswitch2_a" {
  vswitch_name = "fortiadc_vswitch2_internal_a"
  vpc_id       = alicloud_vpc.fortiadc_vpc.id
  cidr_block   = var.fortiadc_vswitch_a_cidr_vswitch2_a
  zone_id      = var.zone_id_2
}

//Security Group for fortigate instances
resource "alicloud_security_group" "fortiadc_SecGroup" {
  name        = "${var.cluster_name}-SecGroup-${random_string.random_name_post.result}"
  description = "New security group"
  vpc_id      = alicloud_vpc.fortiadc_vpc.id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "fortiadc_allow_all_ingress" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.fortiadc_SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}

