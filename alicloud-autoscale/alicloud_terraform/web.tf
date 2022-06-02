variable "web_vm_password" {
  type = string
  default = "Welcome.123"
}

variable "number_web_vm" {
   type = number
   default = 0
}

data "template_file" "web_user_data" {
  template = file("${path.module}/web_user_data.sh")
}
data "alicloud_instance_types" "web_types_ds" {
  cpu_core_count = 1
  memory_size    = 1
}

resource "alicloud_instance" "web-a" {
  count =var.number_web_vm 
  depends_on=[alicloud_vswitch.vsw2]
  user_data = "${data.template_file.web_user_data.rendered}"
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  security_groups = alicloud_security_group.SecGroup.*.id
 // instance_type = "${data.alicloud_instance_types.web_types_ds.instance_types.0.id}"
  instance_type ="ecs.c6.large"
  system_disk_category = "cloud_efficiency"
  instance_name        = "web-a"
  vswitch_id           = alicloud_vswitch.vsw.id
  private_ip           = "172.16.2.20${count.index}"
  password             = var.web_vm_password
  host_name            = "web-a"

}

output "web_port_8080_user_root_password" {
  value = var.web_vm_password
}

output "web_port_8080_ipaddress" {
  value = alicloud_instance.web-a.*.private_ip
}
