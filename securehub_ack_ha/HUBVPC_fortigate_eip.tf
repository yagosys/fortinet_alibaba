resource "alicloud_eip" "FgaMgmtEip" {
  name                 = "EIP1"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip" "FgbMgmtEip" {
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
  allocation_id      = alicloud_eip.FgaMgmtEip.id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.PrimaryFortiGateInterface3.id
  private_ip_address = "${var.activeport4}"
}

resource "alicloud_eip_association" "eip_asso_fgb_mgmt" {
  allocation_id      = alicloud_eip.FgbMgmtEip.id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.SecondaryFortiGateInterface3.id
  private_ip_address = "${var.passiveport4}"
}



resource "alicloud_eip_association" "eip_asso_fga_port1" {
  allocation_id = alicloud_eip.PublicInternetIp.id
  instance_id   = alicloud_instance.PrimaryFortigate.id
}

output "ActiveFortigateEIP3" {
  value = alicloud_eip.PublicInternetIp.ip_address
}

output "PrimaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgaMgmtEip.ip_address
}

output "SecondaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgbMgmtEip.ip_address
}
