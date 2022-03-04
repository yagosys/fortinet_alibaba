output "Public_IP" {
  value = "${alicloud_instance.windowsInstance.public_ip}"
}

output "vpc" {
  value = alicloud_vpc.vpc.name
}
