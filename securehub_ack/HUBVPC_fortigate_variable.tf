variable "client_source_ip_subnet" {
  default = "13.0.0.0/255.255.255.0"
}
variable "admin_api_user" {
  type = string
  default ="soc2"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
}

// HTTPS access port
variable "adminsport" {
  default = "8443"
}

variable "activeport1mask" {
  default = "255.255.255.0"
}


variable "activeport2mask" {
  default = "255.255.255.0"
}


variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "config-active.conf"
}




