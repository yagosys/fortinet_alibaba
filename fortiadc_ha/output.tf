output "admin_SSH_IP_PORT" {
  value = alicloud_instance.FortinetInstance[*].public_ip
}
output "URL_for_access_PrimaryFortigateMGMTIP" {
  value = alicloud_instance.FortinetInstance[*].public_ip
}

output "primary_IP" {
  value = alicloud_instance.FortinetInstance[*].private_ip
}

output "default_password" {
  value = alicloud_instance.FortinetInstance[*].id
}

output "vpc" {
  value = alicloud_vpc.vpc.name
}
