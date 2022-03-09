//Security Group for fortigate instances
resource "alicloud_security_group" "SecGroup" {
  name        = "${var.cluster_name}-SecGroup-${random_string.random_name_post.result}"
  description = "New security group"
  vpc_id      = alicloud_vpc.vpc.id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}
