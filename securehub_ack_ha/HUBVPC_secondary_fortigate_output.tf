output "SecondaryFortigatePublicIP" {
  value = "${alicloud_instance.SecondaryFortigate[*].public_ip}"
}

output "SecondaryFortigateAvailability_zone" {
  value = "${alicloud_instance.SecondaryFortigate[*].availability_zone}"
}

output "SecondaryFortigatePrivateIP" {
  value = "${alicloud_instance.SecondaryFortigate[*].private_ip}"
}

output "SecondaryFortigateport2IP" {
  value = "${alicloud_network_interface.SecondaryFortiGateInterface1.private_ip}"
}


output "SecondaryFortigateID" {
  value = "${alicloud_instance.SecondaryFortigate[*].id}"
}

output "SecondaryFortigateAdminGUI_PORT" {
  value = local.adminsport
}
