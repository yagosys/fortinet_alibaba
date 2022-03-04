resource "alicloud_security_group" "SecGroup" {
  name        = "${var.instance_name}-SecGroup-${random_string.random_name_post.result}"
  description = "SecGroup-Terraform"
  vpc_id      = alicloud_vpc.vpc.id
}



resource "alicloud_security_group_rule" "allow_all_tcp_ssh_ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "allow_all_tcp_https_ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_all_tcp_http_ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_all_icmp_ingress" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}
