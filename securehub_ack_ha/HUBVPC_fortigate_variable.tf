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

variable "activeport3" {
  default = "192.168.13.11"
}

variable "activeport3mask" {
  default = "255.255.255.0"
}

variable "activeport4" {
  default = "192.168.14.11"
}

variable "activeport4mask" {
  default = "255.255.255.0"
}

variable "passiveport3" {
  default = "192.168.23.12"
}

variable "passiveport3mask" {
  default = "255.255.255.0"
}

variable "passiveport4" {
  default = "192.168.24.12"
}

variable "passiveport4mask" {
  default = "255.255.255.0"
}


variable "activeport4gateway" {
  default = "192.168.14.253"
}
variable "passiveport4gateway" {
  default = "192.168.24.253"
}
