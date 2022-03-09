
variable "fortigate_ip_or_fqdn" {
  type = string
  default = "1.1.1.1"
}

variable "fortigate_interface" {
  type = string
  default = "port1"
}
variable "tunnel_name_prefix" {
  type = string
  default = "demo"
}

variable "remote_cidr" {
  type = string
  default = "192.168.184.0/255.255.255.0"
}


variable "firewall_address_name" {
  type = string
  default = "demo"
}

variable "tunnel_phase1_proposal" {
    type = string
    default = "demo"
}

variable "tunnel_phase2_proposal" {
    type = string
    default = "demo"
}

variable "tunnel_info" {
  type = list(object({
    tunnel_ip = string
    tunnel_psk = string
    tunnel_route_distance = number
  }))
    default = [
    {
      tunnel_ip             = "hk.computenest.top"
      tunnel_psk            = "fortinet"
      tunnel_route_distance = 2
    },
    {
      tunnel_ip             = "5.6.7.8"
      tunnel_psk            = "fortinet"
      tunnel_route_distance = 3
    },
  ]
}

variable "peer_fortigate_port1_publicip" {
   type  = string
   default="47.95.122.136/32" //fortigate
}
