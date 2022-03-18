
resource "alicloud_eip_association" "eip_asso_fga_port1" {
depends_on=[time_sleep.wait_180_seconds_after_create_Primary_fortigate[0]]
  count = var.eip=="1" ? 1 : 0 
  allocation_id = alicloud_eip.PublicInternetIp[count.index].id
  instance_id   = alicloud_instance.PrimaryFortigate.id
}

output "ActiveFortigateEIP3" {
  value = var.eip=="1" ? alicloud_eip.PublicInternetIp.*.ip_address : null
}
