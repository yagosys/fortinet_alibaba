data "template_file" "activeFortiAdc" {
    template = file("${path.module}/fortiadc_active_config.conf")
vars = {
    license_type            = "${var.license_type}"
    activelicense           = "${var.activelicense}"
    activeconfig            = "${var.activeconfig}"
 }
}
data "template_file" "passiveFortiAdc" {
    template = file("${path.module}/fortiadc_passive_config.conf")
vars = {
    license_type            = "${var.license_type}"
    passivelicense           = "${var.passivelicense}"
    passiveconfig            = "${var.passiveconfig}"
 }
}

resource "alicloud_instance" "FortinetInstance" {
  count=local.num_instances
  depends_on =[alicloud_security_group_rule.allow_all_icmp_ingress]
  availability_zone = data.alicloud_zones.default.zones.0.id
  image_id          = var.instance_ami

  instance_type = var.instance !="auto" ? var.instance : data.alicloud_instance_types.types_ds.instance_types.0.id

  system_disk_size           = 60
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "fortinet"
  system_disk_description    = "fortinet_system_disk"
  internet_max_bandwidth_out = 100
  security_groups   = alicloud_security_group.SecGroup.*.id
  role_name = alicloud_ram_role.fortiadcrole.id
  user_data = count.index==0 ? data.template_file.activeFortiAdc.rendered : data.template_file.passiveFortiAdc.rendered

data_disks {
    name        = "disk2"
    size        = 20
    category    = "cloud_efficiency"
    description = "disk2"
  }

  instance_name              = "${var.cluster_name}-${random_string.random_name_post.result}-${count.index}"
  vswitch_id                 = alicloud_vswitch.vswitch1_a.id
  private_ip = var.vswitch_a_cidr_vswitch1_a_ip[count.index]
  tags = {
    Name = "terraform_created"
  }
}
