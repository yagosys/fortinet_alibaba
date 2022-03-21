variable "custom_rt" {
default=1
validation {
    condition     =  contains([1, 0], var.custom_rt)
    error_message = "Must be 1 or 0, 1 means create custom routing table, 0 means not."
  }
}
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
            ha_priority=[
		     "200",
		     "100",
	        ]
            defaultgwy = [
		    "10.0.11.253",
		    "10.0.21.253",
                ]
            port2gateway = [
		     "10.0.12.253",
		     "10.0.22.253",
		]
	    mgmt_gateway_ip =[
		    "10.0.14.253",
		    "10.0.24.253",
		]
	    ha_peer_ip = [
		    "10.0.23.12",
	            "10.0.13.11"
                ]
  }
}


variable cidr_block {
type = map(any)
	default = {
		external = [
			"10.0.11.0/24",
			"10.0.21.0/24",
		]
		internal = [
			"10.0.12.0/24",
			"10.0.22.0/24",
		]
		ha = [
			"10.0.13.0/24",
		 	"10.0.23.0/24",
		]
		mgmt = [
			"10.0.14.0/24",
			"10.0.24.0/24",
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
		   "10.0.21.12",
		]
              internal = [
		   "10.0.12.11",
		   "10.0.22.12",
		]
	      ha = [
		   "10.0.13.11",
		   "10.0.23.12",
		]
	      mgmt = [
		    "10.0.14.11",
		    "10.0.24.12",
		]
	}
}

variable "default_egress_route" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
default= "ecs.hfc6.2xlarge"
}

variable "number_of_fortigate" {
default= 2
}

variable "number_of_zone" {
default = 1
validation {
    condition     =  contains([2,1, 0], var.number_of_zone)
    error_message = "Must be 0 ,1 or 2 , 0  means do not create additional ENI, 1 means single zone HA, 4 ENI will be created in one zone, 2 means cross zone HA, 4 ENI will be created in each zone." 
  }
}

variable "mgmt_eip" {
default = 1
validation {
    condition     =  contains([1, 0], var.mgmt_eip)
    error_message = "Must be 0 ,1  0  means do not create eip for management port (port4), 1 means create eip for management port."
  }

}

variable "eip" {
default= 1
validation {
   condition = contains ([1,0], var.eip)
   error_message = "Must be 0, 1  0 means do not create eip for port1 , 1 means create eip for active port1."
}
}

data "alicloud_zones" "default" {
#available_instance_type =var.instance_type
available_instance_type = var.instance_type != "auto" ? var.instance_type : coalesce(length(data.alicloud_zones.default_hfc6.zones) >1  ? data.alicloud_zones.default_hfc6.available_instance_type : "", length(data.alicloud_zones.default_c5.zones) >1  ? data.alicloud_zones.default_c5.available_instance_type : "", length(data.alicloud_zones.default_hfc5.zones) > 1 ?data.alicloud_zones.default_hfc5.available_instance_type : "", length(data.alicloud_zones.default_sn1ne.zones) >1 ?data.alicloud_zones.default_sn1ne.available_instance_type : "")
}

data "alicloud_zones" "default_sn1ne" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.sn1ne.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_hfc6" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.hfc6.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_c5" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.c5.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_zones" "default_hfc5" {
 available_instance_type = var.instance_type !="auto" ? var.instance_type : element(concat([for instance  in data.alicloud_instance_types.types_ds.instance_types.*.id : instance if (contains(["ecs.hfc5.2xlarge"], instance))],["ecs.hfc6.placehold"]),0)
 available_resource_creation = "VSwitch"
}
data "alicloud_instance_types" "types_ds" {
  cpu_core_count       = 8
  memory_size          = 16
  eni_amount = 4
}
variable image_id {
 default="auto"
}
variable "most_recent_image_search_string_from_marketplace" {
   type = string
   default = "FortiGate-6.4.5.+BYOL"
}

data "alicloud_images" "ecs_image" {
  count = var.image_id=="auto"? 1:0
  owners = "marketplace"
  most_recent = true
  name_regex = var.most_recent_image_search_string_from_marketplace
}
