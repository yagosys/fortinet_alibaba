resource "alicloud_eip" "PublicInternetIp" {
  count = var.eip=="1" ? 1 : 0
  name                 = "EIP3"
  bandwidth            = "5"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "eip_asso_fga_port1" {
  count = var.eip=="1" ? 1 : 0 
  allocation_id = alicloud_eip.PublicInternetIp[count.index].id
  instance_id   = alicloud_instance.PrimaryFortigate.id
}

output "ActiveFortigateEIP3" {
  value = alicloud_eip.PublicInternetIp.*.ip_address
}
