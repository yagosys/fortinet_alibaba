variable fortigate {
type =map(any)
    default = {
            hostname=[
		    "fortigate-active",
		    "fortigate-passive",
		]
            license_file=[
		    "./FGVMULTM22000730.lic",
		    "./FGVMULTM22000750.lic",
		]
	    internet_max_bandwidth_out=[
		    "100",
		    "100",
		]
            defaultgwy = [
		    "10.0.11.253",
		    "10.0.11.253",
                ]
            port2gateway = [
		     "10.0.12.253",
		     "10.0.12.253",
		]
	    mgmt_gateway_ip =[
		    "10.0.14.253",
		    "10.0.14.253",
		]
	    ha_peer_ip = [
		    "10.0.13.12",
	            "10.0.13.11"
                ]
  }
}


variable cidr_block {
type = map(any)
	default = {
		external = [
			"10.0.11.0/24",
		]
		internal = [
			"10.0.12.0/24",
		]
		ha = [
			"10.0.13.0/24",
		]
		mgmt = [
			"10.0.14.0/24",
		]
		internal_cidr = [
			"10.0.0.0/16"
		]
	}
}
variable cidr_block_ip {
type = map(any)
       default = {
	     external = [
		   "10.0.11.11",
		   "10.0.11.12",
		]
              internal = [
		   "10.0.12.11",
		   "10.0.12.12",
		]
	      ha = [
		   "10.0.13.11",
		   "10.0.13.12",
		]
	      mgmt = [
		    "10.0.14.11",
		    "10.0.14.12",
		]
	}
}

variable "instance_type" {
default= "ecs.hfc6.2xlarge"
}
variable "number_of_fortigate" {
default= 2
}
variable "number_of_zone" {
default = 1
}

data "alicloud_zones" "default" {
available_instance_type =var.instance_type
}

resource "alicloud_vswitch" "internal_a" {
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["internal"][count.index]
 zone_id=data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "external_a" {
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["external"][count.index]
 zone_id=data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "ha_a" {
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["ha"][count.index]
 zone_id=data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "mgmt_a" {
 count=var.number_of_zone
 vpc_id =module.vswitch.vpc-id
 cidr_block=var.cidr_block["mgmt"][count.index]
 zone_id=data.alicloud_zones.default.zones.0.id
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface1" {
  count=var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = alicloud_vswitch.internal_a[0].id
  security_groups = module.vswitch.sg-id
  private_ip=var.cidr_block_ip["internal"][count.index]
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface2" {
  depends_on=[alicloud_network_interface.PrimaryFortiGateInterface1]
  count=var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = alicloud_vswitch.ha_a[0].id
  security_groups = module.vswitch.sg-id
  private_ip=var.cidr_block_ip["ha"][count.index]
}

resource "alicloud_network_interface" "PrimaryFortiGateInterface3" {
  depends_on=[alicloud_network_interface.PrimaryFortiGateInterface2]
  count=var.number_of_fortigate
  network_interface_name = "createdByTerraform"
  vswitch_id      = alicloud_vswitch.mgmt_a[0].id
  security_groups = module.vswitch.sg-id
  private_ip=var.cidr_block_ip["mgmt"][count.index]
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment1" {
 count = var.number_of_fortigate
depends_on           = [alicloud_network_interface.PrimaryFortiGateInterface1]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface1[count.index].id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment2" {
  count = var.number_of_fortigate
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment1]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface2[count.index].id
}

resource "alicloud_network_interface_attachment" "PrimaryFortigateattachment3" {
  count= var.number_of_fortigate
  depends_on           = [alicloud_network_interface_attachment.PrimaryFortigateattachment2]
  instance_id          = alicloud_instance.PrimaryFortigate[count.index].id
  network_interface_id = alicloud_network_interface.PrimaryFortiGateInterface3[count.index].id
}


resource "alicloud_instance" "PrimaryFortigate" {
 count= var.number_of_fortigate
 instance_name="fortigate${count.index}-${module.random_string.random-string}"
 availability_zone =data.alicloud_zones.default.zones.0.id
 security_groups   = module.vswitch.sg-id
 instance_type = var.instance_type
 vswitch_id           = alicloud_vswitch.external_a[0].id
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

