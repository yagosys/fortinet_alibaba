resource "alicloud_vswitch" "internal_a" {
 name="internal_a"
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["internal"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_vswitch" "external_a" {
 name="external_a"
 count= var.number_of_zone==0 ? 1: var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["external"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_vswitch" "ha_a" {
 name="ha_a"
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["ha"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_vswitch" "mgmt_a" {
 name="mgmt_a"
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["mgmt"][count.index]
 zone_id=element(data.alicloud_zones.default.zones.*.id,count.index)
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
depends_on = [alicloud_route_table_attachment.custom_route_table_attachment_internal]
//wait for vswitch to cool down
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  network_interface_name = "createdByTerraform"

  vswitch_id      = var.number_of_zone==1 ? alicloud_vswitch.internal_a[0].id : alicloud_vswitch.internal_a[count.index].id
  security_groups = module.vswitch.sg-id

  private_ip=var.cidr_block_ip["internal"][count.index]
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface2" {
  depends_on=[alicloud_network_interface.PrimaryFortiGateInterface1]
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = var.number_of_zone==1 ? alicloud_vswitch.ha_a[0].id : alicloud_vswitch.ha_a[count.index].id
  security_groups = module.vswitch.sg-id
  private_ip=var.cidr_block_ip["ha"][count.index]
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface3" {
  depends_on=[alicloud_network_interface.PrimaryFortiGateInterface2]
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = var.number_of_zone==1 ? alicloud_vswitch.mgmt_a[0].id : alicloud_vswitch.mgmt_a[count.index].id
  security_groups = module.vswitch.sg-id
  private_ip=var.cidr_block_ip["mgmt"][count.index]
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
depends_on           = [alicloud_network_interface.PrimaryFortiGateInterface1]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment2" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment1]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface2[count.index].id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment3" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment2]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface3[count.index].id
}

resource "alicloud_route_table" "custom_route_tables" {
  count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
  vpc_id      = module.vswitch.vpc-id
  route_table_name        = "rt-${count.index}"
  description = "hubvpc internal route tables, nexthop to fortigate port 2-eni created with terraform."
}

resource "alicloud_route_table_attachment" "custom_route_table_attachment_internal" {
  count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
//PrimaryFortiGateInterface1 is bound to internal_a vswitch, it can't happen at same time when attach routing table to same vswitch . 
//  depends_on = [alicloud_network_interface.PrimaryFortiGateInterface1]
  vswitch_id     = alicloud_vswitch.internal_a[count.index].id
  route_table_id = alicloud_route_table.custom_route_tables[count.index].id
}

resource "alicloud_route_entry" "internal_rt_default_route_to_eni" {
  depends_on            = [alicloud_network_interface.PrimaryFortiGateInterface1]
  count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_zone
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.default_egress_route
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
}

resource "alicloud_instance" "PrimaryFortigate" {
 count= var.number_of_fortigate
 instance_name="fortigate${count.index}-${module.random_string.random-string}"
 availability_zone =element(data.alicloud_zones.default.zones.*.id,count.index)
 security_groups   = module.vswitch.sg-id
 instance_type = var.instance_type
 vswitch_id           = var.number_of_zone==1 ? alicloud_vswitch.external_a[0].id : alicloud_vswitch.external_a[count.index].id
 role_name =module.ram_role.ram_role-id
 private_ip=var.cidr_block_ip["external"][count.index]
 internet_max_bandwidth_out=var.fortigate["internet_max_bandwidth_out"][count.index]
 user_data     = templatefile( 
"config-active.conf",
{
port1_ip=var.cidr_block_ip["external"][count.index],
port1_mask=cidrnetmask(var.cidr_block["external"][length(var.cidr_block["external"])-1])
defaultgwy=var.fortigate["defaultgwy"][count.index]
port2_ip=var.cidr_block_ip["internal"][count.index],
port2_mask=cidrnetmask(var.cidr_block["internal"][length(var.cidr_block["internal"])-1])
port2gateway=var.fortigate["port2gateway"][count.index]
port3_ip=var.cidr_block_ip["ha"][count.index]
port3_mask=cidrnetmask(var.cidr_block["ha"][length(var.cidr_block["ha"])-1])
port4_ip=var.cidr_block_ip["mgmt"][count.index]
port4_mask=cidrnetmask(var.cidr_block["mgmt"][length(var.cidr_block["mgmt"])-1])
internal_cidr_mask = cidrnetmask(var.cidr_block["internal_cidr"][length(var.cidr_block["internal_cidr"])-1])
internal_cidr=cidrhost(var.cidr_block["internal_cidr"][length(var.cidr_block["internal_cidr"],)-1],0)
ha_priority=var.fortigate["ha_priority"][count.index]
mgmt_gateway_ip=var.fortigate["mgmt_gateway_ip"][count.index]
ha_peer_ip=var.fortigate["ha_peer_ip"][count.index]
type="byol",
license_file=file(var.fortigate["license_file"][count.index]),
hostname    =     var.fortigate["hostname"][count.index]
}
)

image_id="m-j6cj2liju58d88zmgbdg"

}

module "ram_role" {
  source = "../ram"
}


module "vswitch" {
  source  = "../vpc"
}

module "random_string" {
 source = "../global"
}

