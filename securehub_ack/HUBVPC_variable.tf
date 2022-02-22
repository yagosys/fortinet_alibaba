variable "hubvpc_vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "vswitch_a_cidr_1" {
  type    = string
  default = "192.168.11.0/24"
}

variable "vswitch_a_cidr_2" {
  type    = string
  default = "192.168.12.0/24"
}

variable "vswitch_a_cidr_3" {
  type = string
  default = "192.168.13.0/24"
}

variable "vswitch_b_cidr_1" {
  type    = string
  default = "192.168.21.0/24"
}

variable "vswitch_b_cidr_2" {
  type    = string
  default = "192.168.22.0/24"
}

variable "vswitch_b_cidr_3" {
   type = string
   default = "192.168.23.0/24"
}

variable "vswitch_c_cidr_1" {
  type    = string
  default = "192.168.31.0/24"
}

variable "vswitch_c_cidr_2" {
  type    = string
  default = "192.168.32.0/24"
}
variable "vswitch_c_cidr_3" {
   type = string
   default = "192.168.33.0/24"
}


variable "ack1_node_pod_subnet" {
   default = "10.1.0.0/23"
}

variable "ack2_node_pod_subnet" {
   default = "10.0.0.0/23"
}

variable "primary_fortigate_private_ip" {

  type    = string
  default = "192.168.11.11"
}

variable "primary_fortigate_secondary_private_ip" {

  type    = string
  default = "192.168.12.11"
}

variable "primary_fortigate_private_ip_gateway" {
  default = "192.168.11.253"
}

variable "primary_fortigate_private_ip_mask" {
  default = "255.255.255.0"
}

variable "primary_fortigate_secondary_private_ip_gateway" {
  default = "192.168.12.253"
}

variable "primary_fortigate_secondary_private_ip_mask" {
   default = "255.255.255.0"
}

variable "client_vm_private_ip" {
   default = "192.168.12.60"
}

