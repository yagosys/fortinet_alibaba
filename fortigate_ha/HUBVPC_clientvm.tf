
data "alicloud_instance_types" "client_vm_types_ds" {
  cpu_core_count = 2
  memory_size    = 4
}

variable "fadLicense" {
  default = "./FADV040000225874.lic"
}

resource "alicloud_instance" "client-vm" {
  depends_on=[alicloud_instance.PrimaryFortigate,time_sleep.wait_60_seconds_after_create_internal_a_vswitch]
  count = var.create_client_vm=="1"? 1 : 0 
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  internet_max_bandwidth_out = var.client_vm_internet_max_bandwidth_out=="1" ? 10 : null
  security_groups = alicloud_security_group.SecGroup.*.id
  instance_type = var.client_vm_instance_type
 instance_name              = "client-ubuntu-${random_string.random_name_post.result}"
  vswitch_id                 = alicloud_vswitch.internal_a_0.id
  password= var.client_vm_password
  private_ip = var.client_vm_private_ip
  tags = {
    Name = "Terraform-clientvm"
  }

  provisioner "remote-exec" {
     inline = [
       "apt update"
     ]
   }

connection {
  host= var.eip=="1" ? "${element(alicloud_eip.PublicInternetIp.*.ip_address,0)}" : alicloud_instance.PrimaryFortigate.public_ip
  type = "ssh"
  port = "${var.client_vm_ssh_port}"
  user = "${var.client_vm_username}"
  timeout = "360s"
  password = "${var.client_vm_password}"
}

}


