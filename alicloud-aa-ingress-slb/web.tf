variable "webvm_password" {
  type=string
  default="Welcome.123"
}

data "template_file" "web_user_data" {
  template = file("${path.module}/user_data.sh")
}
data "alicloud_instance_types" "web_types_ds" {
  cpu_core_count = 1
  memory_size    = 1
}

resource "alicloud_instance" "web-a" {
  count =var.number_web_vm
  depends_on=[time_sleep.wait_45_seconds_after_create_vswitch]
  user_data = "${data.template_file.web_user_data.rendered}"
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  security_groups = alicloud_security_group.SecGroup.*.id
 // instance_type = "${data.alicloud_instance_types.web_types_ds.instance_types.0.id}"
  instance_type ="ecs.c6.large"
  system_disk_category = "cloud_efficiency"
  instance_name        = "web${count.index}"
  vswitch_id           = alicloud_vswitch.vsw_internal_B.id
  private_ip           = "172.16.9.20${count.index}"
  password             = var.webvm_password
  host_name            = "web${count.index}"

}

output "web_private_ip" {
  value = var.number_web_vm != 0 ? alicloud_instance.web-a.*.private_ip : null
}

output "webserver_user_root_password" {
  value = var.webvm_password
}
