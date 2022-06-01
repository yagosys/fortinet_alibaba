resource "alicloud_nat_gateway" "nat_gateway" {
    vpc_id = "${alicloud_vpc.vpc.id}"
    name = "${var.cluster_name}-NatGateway-${random_string.random_name_post.result}"
    nat_type = "Enhanced"
    payment_type     = "PayAsYouGo"
    vswitch_id="${alicloud_vswitch.vsw_internal_A.id}"
}

//SNAT entries
resource "alicloud_snat_entry" "snat_one" {
    count = var.eip_for_natgw 
    snat_table_id = alicloud_nat_gateway.nat_gateway.snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.vsw_internal_A.id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}
resource "alicloud_snat_entry" "snat_two" {
    count = var.eip_for_natgw 
    snat_table_id = alicloud_nat_gateway.nat_gateway.snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.vsw_internal_B.id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}

resource "alicloud_snat_entry" "snat_three" {
    count = var.eip_for_natgw
    snat_table_id = alicloud_nat_gateway.nat_gateway.snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.vsw.id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}
resource "alicloud_snat_entry" "snat_four" {
    count = var.eip_for_natgw
    snat_table_id = alicloud_nat_gateway.nat_gateway.snat_table_ids
    source_vswitch_id = "${alicloud_vswitch.vsw2.id}"
    snat_ip = "${alicloud_eip.eip_snat_one[count.index].ip_address}"
    depends_on = ["alicloud_eip_association.eip_asso_snat_one"]
}

//EIPs for SNAT
resource "alicloud_eip" "eip_snat_one" {
    count = var.eip_for_natgw 
    bandwidth            = "100"
    internet_charge_type = "PayByTraffic"
}
resource "alicloud_eip_association" "eip_asso_snat_one" {
    count= var.eip_for_natgw
    allocation_id = "${alicloud_eip.eip_snat_one[count.index].id}"
    instance_id   = "${alicloud_nat_gateway.nat_gateway.id}"
    depends_on = ["alicloud_eip.eip_snat_one"]
}

output "natgatewayid_vswitch_id" {
   value = alicloud_nat_gateway.nat_gateway.name
}

