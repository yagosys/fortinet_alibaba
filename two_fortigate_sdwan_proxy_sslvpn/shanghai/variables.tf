
variable "publiccidraz1" {
  default = "10.0.11.0/24"
}

variable "privatecidraz1" {
  default = "10.0.12.0/24"
}


variable "client_source_ip_subnet" {
  default = "119.0.0.0/255.0.0.0"
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


//  Existing SSH Key on the AWS 
variable "keyname" {
  default = "mykey.pub"
}

// HTTPS access port
variable "adminsport" {
  default = "8443"
}

variable "activeport1" {
  default = "10.0.11.11"
}

variable "activeport1mask" {
  default = "255.255.255.0"
}

variable "activeport2" {
  default = "10.0.12.11"
}

variable "activeport2mask" {
  default = "255.255.255.0"
}


variable "activeport1gateway" {
  default = "10.0.11.253"
}

variable "activeport2gateway" {
  default = "10.0.12.253"
}



variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "config-active.conf"
}


