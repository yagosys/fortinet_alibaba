resource "alicloud_eip" "FgaMgmtEip" {
  count = local.num_secondary_instances
  name                 = "EIP1"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip" "FgbMgmtEip" {
  count = local.num_secondary_instances
  name                 = "EIP2"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip" "PublicInternetIp" {
  name                 = "EIP3"
  bandwidth            = "5"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "eip_asso_fga_mgmt" {
  count = local.num_secondary_instances
  allocation_id      = alicloud_eip.FgaMgmtEip[count.index].id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.PrimaryFortiGateInterface3.id
  private_ip_address = "${var.activeport4}"
}

resource "alicloud_eip_association" "eip_asso_fgb_mgmt" {
  count = local.num_secondary_instances
  allocation_id      = alicloud_eip.FgbMgmtEip[count.index].id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.SecondaryFortiGateInterface3.id
  private_ip_address = "${var.passiveport4}"
}




output "PrimaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgaMgmtEip[*].ip_address
}

output "SecondaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgbMgmtEip[*].ip_address
}
