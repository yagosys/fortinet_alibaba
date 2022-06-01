data "template_file" "setupPrimary" {
  template = "${file("${path.module}/ConfigScripts/primaryfortigateconfigscript")}"
  vars = {
    region     = "${var.region}",
    type = "${var.licensetype}",
    license_file=file("${var.license1}"),
    slb_private_ip="${var.slb_private_ip}",
  }
}
data "template_file" "setupSecondary" {
  template = "${file("${path.module}/ConfigScripts/secondaryfortigateconfigscript")}"
  vars = {
    region     = "${var.region}",
    type = "${var.licensetype}",
    license_file=file("${var.license2}"),
    slb_private_ip="${var.slb_private_ip}",
  }
}

data "alicloud_regions" "current_region_ds" {
  current = true
}

data "alicloud_zones" "default" {
}
//Create a Random String to be used for the PSK secret.
resource "random_string" "psk" {
  length           = 16
  special          = true
  override_special = ""
}

//Random 3 char string appended to the ened of each name to avoid conflicts
resource "random_string" "random_name_post" {
  length           = 3
  special          = true
  override_special = ""
  min_lower        = 3
}








resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr //default is 172.16.0.0/16
  name = "${var.cluster_name}-${random_string.random_name_post.result}"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id = alicloud_vpc.vpc.id
  cidr_block = var.vswitch_cidr_1 //172.16.0.0/24 default
  availability_zone = data.alicloud_zones.default.zones[0].id
}

//zone B
resource "alicloud_vswitch" "vsw2" {
  vpc_id = alicloud_vpc.vpc.id
  cidr_block = var.vswitch_cidr_2 //172.16.8.0/24 default
  availability_zone = data.alicloud_zones.default.zones[1].id
}
resource "alicloud_vswitch" "vsw_internal_A" {
  vpc_id = alicloud_vpc.vpc.id
  cidr_block = var.vswitch_cidr_interal_ZoneA //172.16.0.0/24 default
  availability_zone = data.alicloud_zones.default.zones[0].id
}
resource "alicloud_vswitch" "vsw_internal_B" {
  vpc_id = alicloud_vpc.vpc.id
  cidr_block = var.vswitch_cidr_interal_ZoneB //172.16.0.0/24 default
  availability_zone = data.alicloud_zones.default.zones[1].id
}
// Egress Route to Primary Fortigate
resource "alicloud_route_entry" "egress" {
  count = var.split_egress_traffic == "false" ? 1 : 0
  // The Default Route
  route_table_id = "${alicloud_vpc.vpc.route_table_id}"
  destination_cidrblock = "${var.default_egress_route}" //Default is 0.0.0.0/0
  nexthop_type = "NetworkInterface"
  nexthop_id = "${alicloud_network_interface.PrimaryFortiGateInterface.id}"
}
variable "custom_route_table_count" {
  type = number
  default = 0

}
resource "alicloud_route_table" "custom_route_tables" {
  count = var.split_egress_traffic == "true" ? 2 : 0
  vpc_id = alicloud_vpc.vpc.id
  name = "${var.cluster_name}-FortiGateEgress-${random_string.random_name_post.result}-${count.index}"
  description = "FortiGate Egress route tables, created with terraform."
}

resource "alicloud_route_entry" "custom_route_table_egress" {
  count = var.split_egress_traffic == "true" ? 2 : 0
  route_table_id = "${alicloud_route_table.custom_route_tables[count.index].id}"
  destination_cidrblock = "${var.default_egress_route}" //Default is 0.0.0.0/0
  nexthop_type = "NetworkInterface"
  name = count.index == 0 ? "${alicloud_network_interface.PrimaryFortiGateInterface.id}" : "${alicloud_network_interface.SecondaryFortigateInterface.id}"
  nexthop_id = count.index == 0 ? "${alicloud_network_interface.PrimaryFortiGateInterface.id}" : "${alicloud_network_interface.SecondaryFortigateInterface.id}"
}

resource "alicloud_route_table_attachment" "custom_route_table_attachment_private" {
  count = var.split_egress_traffic == "true" ? 2 : 0
  vswitch_id     = count.index == 0 ? "${alicloud_vswitch.vsw_internal_A.id}" : "${alicloud_vswitch.vsw_internal_B.id}"
  route_table_id = "${alicloud_route_table.custom_route_tables[count.index].id}"
}

//Security Group
resource "alicloud_security_group" "SecGroup" {
  name = "${var.cluster_name}-SecGroup-${random_string.random_name_post.result}"
  description = "New security group"
  vpc_id = alicloud_vpc.vpc.id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress" {
  type = "ingress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "accept"
  port_range = "1/65535"
  priority = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip = "0.0.0.0/0"
}

//Allow All Egress Traffic - ESS
resource "alicloud_security_group_rule" "allow_all_tcp_egress" {
  type = "egress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "accept"
  port_range = "1/65535"
  priority = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip = "0.0.0.0/0"
}

// ECS Instances
// Primary Fortigate

resource "alicloud_instance" "PrimaryFortigate" {
  depends_on =  [alicloud_network_interface.PrimaryFortiGateInterface]
  availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  security_groups = "${alicloud_security_group.SecGroup.*.id}"
  image_id = "${length(var.instance_ami) > 1 ? var.instance_ami : data.alicloud_images.ecs_image.images.0.id}" //grab the first image that matches the regex
  instance_type = "${data.alicloud_instance_types.types_ds.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  instance_name = "${var.cluster_name}-Primary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id = "${alicloud_vswitch.vsw.id}"
  user_data = "${data.template_file.setupPrimary.rendered}"

 // internet_max_bandwidth_in = 200
  internet_max_bandwidth_out = var.fgt_internet_max_bandwidth_out
  private_ip = "${var.primary_fortigate_private_ip}" //Default 172.16.0.100
  //Logging Disk
  data_disks {
    size = 30
    category = "cloud_ssd"
    delete_with_instance = true
  }
}
//Secondary ENI Primary FortiGate
resource "alicloud_network_interface" "PrimaryFortiGateInterface" {
  depends_on =[time_sleep.wait_45_seconds_after_create_vswitch_A]
  name = "${var.cluster_name}-PrimaryPrivateENI-${random_string.random_name_post.result}"
  vswitch_id = "${alicloud_vswitch.vsw_internal_A.id}"
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment" {
  instance_id = "${alicloud_instance.PrimaryFortigate.id}"
  network_interface_id = "${alicloud_network_interface.PrimaryFortiGateInterface.id}"
}

// Secondary Fortigate
resource "alicloud_instance" "SecondaryFortigate" {
  depends_on =  [alicloud_network_interface.SecondaryFortigateInterface]
  availability_zone = "${data.alicloud_zones.default.zones.1.id}"
  security_groups = "${alicloud_security_group.SecGroup.*.id}"
  image_id = "${length(var.instance_ami) > 1 ? var.instance_ami : data.alicloud_images.ecs_image.images.0.id}" //grab the first image that matches the regex
  instance_type = "${data.alicloud_instance_types.types_ds.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  instance_name = "${var.cluster_name}-Secondary-FortiGate-${random_string.random_name_post.result}"
  vswitch_id = "${alicloud_vswitch.vsw2.id}"
  user_data = "${data.template_file.setupSecondary.rendered}"
//  internet_max_bandwidth_in = 200
  internet_max_bandwidth_out = var.fgt_internet_max_bandwidth_out
  private_ip = "${var.secondary_fortigate_private_ip}"

  //Logging Disk
  data_disks {
    size = 30
    category = "cloud_ssd"
    delete_with_instance = true
  }
}
//Secondary ENI Secondary FortiGate
resource "alicloud_network_interface" "SecondaryFortigateInterface" {
  depends_on=[time_sleep.wait_45_seconds_after_create_vswitch]
  name = "${var.cluster_name}-SecondaryPrivateENI${random_string.random_name_post.result}"
  vswitch_id = "${alicloud_vswitch.vsw_internal_B.id}"
  security_groups = ["${alicloud_security_group.SecGroup.id}"]
}

resource "alicloud_network_interface_attachment" "SecondaryFortigateAttachment" {
  instance_id = "${alicloud_instance.SecondaryFortigate.id}"
  network_interface_id = "${alicloud_network_interface.SecondaryFortigateInterface.id}"
}
output "PrimaryFortigateIP" {
  value = var.fgt_internet_max_bandwidth_out !=0 ? alicloud_instance.PrimaryFortigate.public_ip : alicloud_instance.PrimaryFortigate.private_ip 
}
output "PrimaryFortigateID" {
  value = "${alicloud_instance.PrimaryFortigate.id}"
}
output "PrimaryFortiGate_SecondaryENI" {
  value = "${alicloud_network_interface.PrimaryFortiGateInterface.id}"
}
output "SecondaryFortigateIP" {
  value = var.fgt_internet_max_bandwidth_out !=0 ? alicloud_instance.SecondaryFortigate.public_ip : alicloud_instance.SecondaryFortigate.private_ip
}
output "SecondaryFortigateID" {
  value = "${alicloud_instance.SecondaryFortigate.id}"
}
output "SecondaryFortiGate_SecondaryENI" {
  value = "${alicloud_network_interface.SecondaryFortigateInterface.id}"
}
