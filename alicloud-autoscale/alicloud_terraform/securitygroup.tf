//Security Group ESS instances
resource "alicloud_security_group" "SecGroup" {
    name        = "${var.cluster_name}-SecGroup-${random_string.random_name_post.result}"
    description = "New security group"
    vpc_id = "${alicloud_vpc.vpc.id}"
}
//Security Group Function Instances
resource "alicloud_security_group" "SecGroup_FC" {
    name        = "${var.cluster_name}-SecGroup-FC-${random_string.random_name_post.result}"
    description = "New security group"
    vpc_id = "${alicloud_vpc.vpc.id}"
}
//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress" {
    type              = "ingress"
    ip_protocol       = "tcp"
    nic_type          = "intranet"
    policy            = "accept"
    port_range        = "1/65535"
    priority          = 1
    security_group_id = "${alicloud_security_group.SecGroup.id}"
    cidr_ip           = "0.0.0.0/0"
}
//Allow All Egress Traffic - ESS
resource "alicloud_security_group_rule" "allow_all_tcp_egress" {
    type              = "egress"
    ip_protocol       = "tcp"
    nic_type          = "intranet"
    policy            = "accept"
    port_range        = "1/65535"
    priority          = 1
    security_group_id = "${alicloud_security_group.SecGroup.id}"
    cidr_ip           = "0.0.0.0/0"
}
//Allow Private Subnets to access function compute
resource "alicloud_security_group_rule" "allow_a_class_ingress" {
    type              = "ingress"
    ip_protocol       = "tcp"
    nic_type          = "intranet"
    policy            = "accept"
    port_range        = "1/65535"
    priority          = 1
    security_group_id = "${alicloud_security_group.SecGroup_FC.id}"
    cidr_ip           = "10.10.0.0/8"
}
resource "alicloud_security_group_rule" "allow_b_class_ingress" {
    type              = "ingress"
    ip_protocol       = "tcp"
    nic_type          = "intranet"
    policy            = "accept"
    port_range        = "1/65535"
    priority          = 1
    security_group_id = "${alicloud_security_group.SecGroup_FC.id}"
    cidr_ip           = "172.16.0.0/12"
}
resource "alicloud_security_group_rule" "allow_c_class_ingress" {
    type              = "ingress"
    ip_protocol       = "tcp"
    nic_type          = "intranet"
    policy            = "accept"
    port_range        = "1/65535"
    priority          = 1
    security_group_id = "${alicloud_security_group.SecGroup_FC.id}"
    cidr_ip           = "192.168.0.0/16"
}
//Allow All Egress Traffic - Function Compute
resource "alicloud_security_group_rule" "allow_all_tcp_egress_FC" {
    type              = "egress"
    ip_protocol       = "tcp"
    nic_type          = "intranet"
    policy            = "accept"
    port_range        = "1/65535"
    priority          = 1
    security_group_id = "${alicloud_security_group.SecGroup_FC.id}"
    cidr_ip           = "0.0.0.0/0"
}
