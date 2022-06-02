//Nat Gateway
resource "alicloud_nat_gateway" "nat_gateway" {
    vpc_id = "${alicloud_vpc.vpc.id}"
    name = "${var.cluster_name}-NatGateway-${random_string.random_name_post.result}"
    nat_type = "Enhanced"
    payment_type     = "PayAsYouGo"
    vswitch_id="${alicloud_vswitch.vsw.id}"
}

//SNAT entries
resource "alicloud_snat_entry" "snat_one" {
    snat_table_id = element(alicloud_nat_gateway.nat_gateway.snat_table_ids,0) //for old version
    //snat_table_id =alicloud_nat_gateway.nat_gateway.snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.vsw.id}"
    snat_ip = "${alicloud_eip.eip_snat_one.ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}
resource "alicloud_snat_entry" "snat_two" {
    snat_table_id = element(alicloud_nat_gateway.nat_gateway.snat_table_ids,0) //for old version
    //snat_table_id = alicloud_nat_gateway.nat_gateway.snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.vsw2.id}"
    snat_ip = "${alicloud_eip.eip_snat_two.ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_two"]
}
//EIPs for SNAT
resource "alicloud_eip" "eip_snat_one" {
    bandwidth            = "100"
    internet_charge_type = "PayByTraffic"
}
resource "alicloud_eip" "eip_snat_two" {
    bandwidth            = "100"
    internet_charge_type = "PayByTraffic"
}
//EIP associations
resource "alicloud_eip_association" "eip_asso_snat_one" {
    allocation_id = "${alicloud_eip.eip_snat_one.id}"
    instance_id   = "${alicloud_nat_gateway.nat_gateway.id}"
    depends_on = ["alicloud_eip.eip_snat_one"]
}

resource "alicloud_eip_association" "eip_asso_snat_two" {
    allocation_id = "${alicloud_eip.eip_snat_two.id}"
    instance_id   = "${alicloud_nat_gateway.nat_gateway.id}"
    depends_on = ["alicloud_eip.eip_snat_two"]
}
