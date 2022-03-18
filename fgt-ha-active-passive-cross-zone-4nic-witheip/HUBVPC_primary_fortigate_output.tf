output "PrimaryFortigatePublicIP" {
  value = "${alicloud_instance.PrimaryFortigate.public_ip}"
}

output "PrimaryFortigateAvailability_zone" {
  value = "${alicloud_instance.PrimaryFortigate.availability_zone}"
}

output "PrimaryFortigatePrivateIP" {
  value = "${alicloud_instance.PrimaryFortigate.private_ip}"
}

output "PrimaryFortigateport2IP" {
  value = "${alicloud_network_interface.PrimaryFortiGateInterface1[*].private_ip}"
}


output "PrimaryFortigateID" {
  value = "${alicloud_instance.PrimaryFortigate.id}"
}

output "PrimaryFortigateAdminGUI_PORT" {
  value = local.adminsport
}
