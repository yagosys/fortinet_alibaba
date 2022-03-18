variable "activefgtlicense" {
  default= ""
}

data "template_file" "activeFortiGate" {
#  template = "${file("${local.bootstrap-active}")}"
    template = file("${path.module}/fortigate_config_active.conf")

  vars = {
    type            = "${local.license_type}"
    #license_file    = "${var.license}"
    license_file     =file("${var.activefgtlicense}")
    port1_ip         = "${var.primary_fortigate_private_ip}"
    port1_mask      = "${var.primary_fortigate_private_ip_mask}"
    port2_ip         = "${var.primary_fortigate_secondary_private_ip}"
    port2_mask      = "${var.primary_fortigate_secondary_private_ip_mask}"
    port3_ip                = "${local.activeport3}"
    port3_mask              = "${local.activeport3mask}"
    port4_ip                = "${local.activeport4}"
    port4_mask              = "${local.activeport4mask}"
    passive_peerip          = "${local.passiveport3}"
    mgmt_gateway_ip         = "${local.activeport4gateway}"
    defaultgwy      = "${var.primary_fortigate_private_ip_gateway}"
    privategwy      = "${var.primary_fortigate_secondary_private_ip_gateway}"
    vpc_ip          = cidrhost(var.hubvpc_vpc_cidr, 0)
    vpc_mask        = cidrnetmask(var.hubvpc_vpc_cidr)
    adminsport      = "${local.adminsport}"
    client_source_ip_subnet = "${local.client_source_ip_subnet}"
    admin_api_user = "${local.admin_api_user}"
    client_vm = "${var.client_vm_private_ip}"
  }
}


