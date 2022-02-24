

variable "publiccidraz1" {
  default = "192.168.11.0/24"
}

variable "privatecidraz1" {
  default = "192.168.12.0/24"
}

variable "hasynccidraz1" {
  default = "192.168.13.0/24"
}

variable "hamgmtcidraz1" {
  default = "192.168.14.0/24"
}

variable "publiccidraz2" {
  default = "192.168.21.0/24"
}

variable "privatecidraz2" {
  default = "192.168.22.0/24"
}

variable "hasynccidraz2" {
  default = "192.168.23.0/24"
}

variable "hamgmtcidraz2" {
  default = "192.168.24.0/24"
}

variable "client_source_ip_subnet" {
  default = "13.0.0.0/255.255.255.0"
}

variable "admin_api_user" {
  type    = string
  default = "soc2"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
}



//variable "size" {
// default = "c5n.xlarge"
//}

//  Existing SSH Key 

// HTTPS access port
variable "adminsport" {
  default = "8443"
}

variable "activeport1" {
  default = "192.168.11.11"
}

variable "activeport1mask" {
  default = "255.255.255.0"
}

variable "activeport2" {
  default = "192.168.12.11"
}

variable "activeport2mask" {
  default = "255.255.255.0"
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

variable "passiveport1" {
  default = "192.168.21.12"
}

variable "passiveport1mask" {
  default = "255.255.255.0"
}

variable "passiveport2" {
  default = "192.168.22.12"
}

variable "passiveport2mask" {
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

variable "activeport1gateway" {
  default = "192.168.11.253"
}

variable "activeport2gateway" {
  default = "192.168.12.253"
}

variable "activeport4gateway" {
  default = "192.168.14.253"
}

variable "passiveport1gateway" {
  default = "192.168.21.253"
}

variable "passiveport2gateway" {
  default = "192.168.22.253"
}

variable "passiveport4gateway" {
  default = "192.168.24.253"
}


variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "config-active.conf"
}

variable "bootstrap-passive" {
  // Change to your own path
  type    = string
  default = "config-passive.conf"
}
