resource "alicloud_eip" "FgaMgmtEip" {
  count = var.mgmt_eip=="1" ? 1:0
  name                 = "EIP1"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip" "FgbMgmtEip" {
  count = var.num_secondary_instances=="1" ? 1:0
  name                 = "EIP2"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}


resource "alicloud_eip_association" "eip_asso_fga_mgmt" {
  count = var.mgmt_eip=="1" ? 1:0

 depends_on = [time_sleep.wait_60_seconds_after_create_primary_fortigate_interface3]
  allocation_id      = alicloud_eip.FgaMgmtEip[count.index].id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.PrimaryFortiGateInterface3.id
  private_ip_address = "${local.activeport4}"
}

resource "alicloud_eip_association" "eip_asso_fgb_mgmt" {
 depends_on = [time_sleep.wait_60_seconds_after_create_secondary_fortigate_interface3,alicloud_eip.FgbMgmtEip]
  count = var.mgmt_eip=="1" ? 1:0
  allocation_id      = alicloud_eip.FgbMgmtEip[count.index].id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.SecondaryFortiGateInterface3.id
  private_ip_address = "${local.passiveport4}"
}




output "PrimaryFortigate_MGMT_EIP" {
  value = var.mgmt_eip == "1" ? alicloud_eip.FgaMgmtEip[*].ip_address : null
}

output "SecondaryFortigate_MGMT_EIP" {
  value = var.mgmt_eip == "1" ? alicloud_eip.FgbMgmtEip[*].ip_address : null
}

resource "alicloud_eip" "PublicInternetIp" {
  count = var.eip=="1" ? 1 : 0
  name                 = "EIP3"
  bandwidth            = "5"
  internet_charge_type = "PayByTraffic"
}
