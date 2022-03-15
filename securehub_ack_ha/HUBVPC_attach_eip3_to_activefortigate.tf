resource "alicloud_eip_association" "eip_asso_fga_port1" {
//depends_on = [alicloud_cen_transit_router_vpc_attachment.atta_fortiadc]
  allocation_id = alicloud_eip.PublicInternetIp.id
  instance_id   = alicloud_instance.PrimaryFortigate.id
}

output "ActiveFortigateEIP3" {
  value = alicloud_eip.PublicInternetIp.ip_address
}
