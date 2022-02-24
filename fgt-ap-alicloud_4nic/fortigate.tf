//data "alicloud_regions" "current_region_ds" {
// current = true
//}

data "alicloud_eips" "eips_ds" {
}

resource "random_string" "psk" {
  length           = 16
  special          = true
  override_special = ""
}


resource "random_string" "random_name_post" {
  length           = 4
  special          = true
  override_special = ""
  min_lower        = 4
}




resource "alicloud_eip" "FgaMgmtEip" {
  name                 = "EIP1"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip" "FgbMgmtEip" {
  name                 = "EIP2"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}



resource "alicloud_eip_association" "eip_asso_fga_mgmt" {
  allocation_id      = alicloud_eip.FgaMgmtEip.id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.PrimaryFortiGateInterface3.id
  private_ip_address = "${var.activeport4}"
}

resource "alicloud_eip_association" "eip_asso_fgb_mgmt" {
  allocation_id      = alicloud_eip.FgbMgmtEip.id
  instance_type      = "NetworkInterface"
  instance_id        = alicloud_network_interface.SecondaryFortiGateInterface3.id
 // private_ip_address = "192.168.24.12"
  private_ip_address = "${var.passiveport4}"
}


resource "alicloud_eip" "PublicInternetIp" {
  name                 = "EIP3"
  bandwidth            = "5"
  internet_charge_type = "PayByTraffic"
}


resource "alicloud_eip_association" "eip_asso_fga_port1" {
  allocation_id = alicloud_eip.PublicInternetIp.id
  instance_id   = alicloud_instance.PrimaryFortigate.id
}



resource "alicloud_instance" "PrimaryFortigate" {
//  depends_on = [alicloud_network_interface.PrimaryFortiGateInterface3]

  availability_zone = data.alicloud_zones.default.zones.0.id

  security_groups = alicloud_security_group.SecGroup.*.id


  image_id = length(var.instance_ami) > 5 ? var.instance_ami : data.alicloud_images.ecs_image.images.0.id

  user_data     = data.template_file.activeFortiGate.rendered
// instance_type = data.alicloud_instance_types.types_ds.instance_type_family
 instance_type = coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")
  instance_name = "${var.cluster_name}-Primary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id    = alicloud_vswitch.external_a.id
  private_ip    = var.primary_fortigate_private_ip
  role_name     = var.iam !="Fortigate-HA-New" ? alicloud_ram_role.role[0].id : var.iam
  
  tags = {
    Name = "FGT1"
  }
  //Logging Disk
  data_disks {
    size                 = 30
    category             = "cloud_essd"
    delete_with_instance = true
  }
}



//for SecondaryForitgate



resource "alicloud_instance" "SecondaryFortigate" {
//  depends_on        = [alicloud_network_interface.SecondaryFortiGateInterface3]
  availability_zone = data.alicloud_zones.default.zones.1.id
  security_groups   = alicloud_security_group.SecGroup.*.id


  image_id = length(var.instance_ami) > 5 ? var.instance_ami : data.alicloud_images.ecs_image.images.0.id

  user_data     = data.template_file.passiveFortiGate.rendered
//  instance_type = data.alicloud_instance_types.types_ds.instance_type_family
 instance_type = coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")

  instance_name = "${var.cluster_name}-Secondary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id    = alicloud_vswitch.external_b.id
  private_ip    = var.secondary_fortigate_private_ip
  role_name     = var.iam !="Fortigate-HA-New" ? alicloud_ram_role.role[0].id : var.iam
  tags = {
    Name = "FGT2"
  }
  data_disks {
    size                 = 30
    category             = "cloud_essd"
    delete_with_instance = true
  }
}

