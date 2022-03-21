variable "custom_rt" {
default=1
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
}

variable "mgmt_eip" {
default = 1
}

variable "eip" {
default= 1
}
data "alicloud_zones" "default" {
available_instance_type =var.instance_type
}

