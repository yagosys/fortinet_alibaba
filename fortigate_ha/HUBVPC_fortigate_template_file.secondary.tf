variable "passivefgtlicense" {
  default= ""
}

data "template_file" "passiveFortiGate" {
#  template = "${file("${local.bootstrap-active}")}"
    template = file("${path.module}/fortigate_config_passive.conf")

  vars = {
    type            = "${local.license_type}"
    license_file     =file("${var.passivefgtlicense}")
    port1_ip         = "${var.secondary_fortigate_private_ip}"
    port1_mask      = "${var.secondary_fortigate_private_ip_mask}"
    port2_ip         = "${var.secondary_fortigate_secondary_private_ip}"
    port2_mask      = "${var.secondary_fortigate_secondary_private_ip_mask}"
    port3_ip                = "${local.passiveport3}"
    port3_mask              = "${local.passiveport3mask}"
    port4_ip                = "${local.passiveport4}"
    port4_mask              = "${local.passiveport4mask}"
    active_peerip          = "${local.activeport3}"
    mgmt_gateway_ip         = "${local.passiveport4gateway}"
    defaultgwy      = "${var.secondary_fortigate_private_ip_gateway}"
    privategwy      = "${var.secondary_fortigate_secondary_private_ip_gateway}"
    vpc_ip          = cidrhost(var.hubvpc_vpc_cidr, 0)
    vpc_mask        = cidrnetmask(var.hubvpc_vpc_cidr)
    adminsport      = "${local.adminsport}"
    client_source_ip_subnet = "${local.client_source_ip_subnet}"
    admin_api_user = "${local.admin_api_user}"
    client_vm = "${var.client_vm_private_ip}"
  }
}


