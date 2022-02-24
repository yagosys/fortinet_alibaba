

data "template_file" "activeFortiGate" {
#  template = file("${var.bootstrap-active}")
  template = file("${path.module}/config-active.conf")
  vars = {
    type                    = "${var.license_type}"
   // license_file            = "${var.license}"
    license_file     =file("${var.license1}")
    port1_ip                = "${var.activeport1}"
    port1_mask              = "${var.activeport1mask}"
    port2_ip                = "${var.activeport2}"
    port2_mask              = "${var.activeport2mask}"
    port3_ip                = "${var.activeport3}"
    port3_mask              = "${var.activeport3mask}"
    port4_ip                = "${var.activeport4}"
    port4_mask              = "${var.activeport4mask}"
    passive_peerip          = "${var.passiveport3}"
    mgmt_gateway_ip         = "${var.activeport4gateway}"
    defaultgwy              = "${var.activeport1gateway}"
    privategwy              = "${var.activeport2gateway}"
    vpc_ip                  = cidrhost(var.vpc_cidr, 0)
    vpc_mask                = cidrnetmask(var.vpc_cidr)
    adminsport              = "${var.adminsport}"
    client_source_ip_subnet = "${var.client_source_ip_subnet}"
    admin_api_user          = "${var.admin_api_user}"
  }
}

data "template_file" "passiveFortiGate" {
#  template = file("${var.bootstrap-passive}")
template = file("${path.module}/config-passive.conf")
  vars = {
    type                    = "${var.license_type}"
   // license_file            = "${var.license2}"
    license_file     =file("${var.license2}")
    port1_ip                = "${var.passiveport1}"
    port1_mask              = "${var.passiveport1mask}"
    port2_ip                = "${var.passiveport2}"
    port2_mask              = "${var.passiveport2mask}"
    port3_ip                = "${var.passiveport3}"
    port3_mask              = "${var.passiveport3mask}"
    port4_ip                = "${var.passiveport4}"
    port4_mask              = "${var.passiveport4mask}"
    active_peerip           = "${var.activeport3}"
    mgmt_gateway_ip         = "${var.passiveport4gateway}"
    defaultgwy              = "${var.passiveport1gateway}"
    privategwy              = "${var.passiveport2gateway}"
    vpc_ip                  = cidrhost(var.vpc_cidr, 0)
    vpc_mask                = cidrnetmask(var.vpc_cidr)
    adminsport              = "${var.adminsport}"
    client_source_ip_subnet = "${var.client_source_ip_subnet}"
    admin_api_user          = "${var.admin_api_user}"
  }
}
