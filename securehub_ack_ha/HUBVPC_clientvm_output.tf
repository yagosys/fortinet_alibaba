output "client-vm" {
 value = coalesce(alicloud_instance.client-vm.public_ip,alicloud_instance.client-vm.private_ip)
}

output "client-vm-ssh-port" {
  value = var.client_vm_ssh_port
}

output "client-vm-password" {
  value = var.client_vm_password
}
