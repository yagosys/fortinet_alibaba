output "fortiadc_public_ip" {
 value = coalesce(alicloud_instance.fortiadc.public_ip,alicloud_instance.fortiadc.private_ip)
//value = alicloud_instance.fortiadc.public_ip
}

output "fortiadc_private_ip" {
value = alicloud_instance.fortiadc.private_ip
}

output "fortiadc_ssh_port" {
 value = 6022
}

output "fortiadc_gui_https_port" {
  value = 9443
}

output "fortiadc_instance_id" {
  value = alicloud_instance.fortiadc.id
}
