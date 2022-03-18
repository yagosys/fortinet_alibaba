output "SecondaryFortigatePublicIP" {
  value = var.num_secondary_instances =="1" ? "${alicloud_instance.SecondaryFortigate[*].public_ip}" : null
}

output "SecondaryFortigateAvailability_zone" {
  value = var.num_secondary_instances =="1" ? "${alicloud_instance.SecondaryFortigate[*].availability_zone}" : null
}

output "SecondaryFortigatePrivateIP" {
  value = var.num_secondary_instances =="1" ? "${alicloud_instance.SecondaryFortigate[*].private_ip}" : null
}

output "SecondaryFortigateport2IP" {
  value = var.num_secondary_instances =="1" ? "${alicloud_network_interface.SecondaryFortiGateInterface1[*].private_ip}" : null
}


output "SecondaryFortigateID" {
  value = var.num_secondary_instances =="1" ? "${alicloud_instance.SecondaryFortigate[*].id}" : null
}

output "SecondaryFortigateAdminGUI_PORT" {
  value = var.num_secondary_instances =="1" ? local.adminsport : null
}
