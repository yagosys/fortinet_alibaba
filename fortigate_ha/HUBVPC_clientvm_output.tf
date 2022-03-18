output "client-vm" {
 value = var.create_client_vm=="1" ? alicloud_instance.client-vm[*].private_ip : null
}

output "client-vm-ssh-port" {
   value = var.create_client_vm=="1" ? var.client_vm_ssh_port : null
}


output "client-vm-password" {
  value = var.create_client_vm=="1" ? var.client_vm_password : null
}
