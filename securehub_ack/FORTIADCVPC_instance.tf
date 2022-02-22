data "template_file" "activeFortiAdc" {
    template = file("${path.module}/fortiadc_config.conf")
}

resource "alicloud_instance" "fortiadc" {
  availability_zone = var.zone_id_1
  image_id          = var.fortiadc_instance_ami

  instance_type = var.fortiadc_instance !="auto" ? var.fortiadc_instance : data.alicloud_instance_types.fortiadc_types_ds.instance_types.0.id

  system_disk_size           = 60
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "fortinet"
  system_disk_description    = "fortinet_system_disk"
  internet_max_bandwidth_out = var.fortiadcpublicip_bandwidth_out 
  role_name = alicloud_ram_role.fortiadcrole.id
  user_data = data.template_file.activeFortiAdc.rendered

  security_groups   = alicloud_security_group.fortiadc_SecGroup.*.id

data_disks {
    name        = "disk2"
    size        = 20
    category    = "cloud_efficiency"
    description = "disk2"
  }

  instance_name              = "fortiadc-${random_string.random_name_post.result}"
  vswitch_id                 = alicloud_vswitch.fortiadc_vswitch1_a.id
  private_ip = var.fortiadc_vswitch_a_cidr_vswitch1_a_ip
  tags = {
    Name = "terraform_created"
  }
}
