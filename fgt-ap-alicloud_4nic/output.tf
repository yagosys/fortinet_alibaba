//for primaryFortigate
output "PrimaryFortigatePublicIP" {
  value = alicloud_instance.PrimaryFortigate.public_ip
}

output "PrimaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgaMgmtEip.ip_address
}

output "PrimaryFortigateAvailability_zone" {
  value = alicloud_instance.PrimaryFortigate.availability_zone
}

output "PrimaryFortigatePrivateIP" {
  value = alicloud_instance.PrimaryFortigate.private_ip
}

output "PrimaryFortigateID" {
  value = alicloud_instance.PrimaryFortigate.id
}

//for secondaryFortigate
output "SecondaryFortigatePublicIP" {
  value = alicloud_instance.SecondaryFortigate.public_ip
}

output "SecondaryFortigate_MGMT_EIP" {
  value = alicloud_eip.FgbMgmtEip.ip_address
}

output "SecondaryFortigateAvailability_zone" {
  value = alicloud_instance.SecondaryFortigate.availability_zone
}


output "SecondaryFortigatePrivateIP" {
  value = alicloud_instance.SecondaryFortigate.private_ip
}

output "SecondaryFortigateID" {
  value = alicloud_instance.SecondaryFortigate.id
}

output "ActiveFortigateEIP3" {
  value = alicloud_eip.PublicInternetIp.ip_address
}

//output "WebStartupFile" {
// value= alicloud_instance.web-a.user_data
//}
