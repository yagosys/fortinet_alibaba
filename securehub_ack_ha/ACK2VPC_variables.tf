//# common variables


variable "example_name_ack2" {
  default = "ack2"
}

variable ack2_vpc_cidr {
   type = string
   default = "10.0.0.0/16"
}

variable ack2_vswitch0_subnet {
    type = string
    default = "10.0.0.0/24"
}

variable ack2_vswitch1_subnet {
    type = string
    default = "10.0.1.0/24"
}
