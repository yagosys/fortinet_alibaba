
data "template_file" "activeFortiGate" {
#  template = "${file("${var.bootstrap-active}")}"
    template = file("${path.module}/config-active.conf")

  vars = {
    type            = "${var.license_type}"
//    license_file    = "${var.license}"
   license_file = file("${var.license}")
    port1_ip        = "${var.activeport1}"
    port1_mask      = "${var.activeport1mask}"
    port2_ip        = "${var.activeport2}"
    port2_mask      = "${var.activeport2mask}"
    defaultgwy      = "${var.activeport1gateway}"
    privategwy      = "${var.activeport2gateway}"
    vpc_ip          = cidrhost(var.vpc_cidr, 0)
    vpc_mask        = cidrnetmask(var.vpc_cidr)
    adminsport      = "${var.adminsport}"
    client_source_ip_subnet = "${var.client_source_ip_subnet}"
    admin_api_user = "${var.admin_api_user}"
  }
}

