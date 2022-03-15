variable "activefgtlicense" {
  default= ""
}

data "template_file" "activeFortiGate" {
#  template = "${file("${var.bootstrap-active}")}"
    template = file("${path.module}/fortigate_config_active.conf")

  vars = {
    type            = "${var.license_type}"
    #license_file    = "${var.license}"
    license_file     =file("${var.activefgtlicense}")
    port1_ip         = "${var.primary_fortigate_private_ip}"
    port1_mask      = "${var.primary_fortigate_private_ip_mask}"
    port2_ip         = "${var.primary_fortigate_secondary_private_ip}"
    port2_mask      = "${var.primary_fortigate_secondary_private_ip_mask}"
    port3_ip                = "${var.activeport3}"
    port3_mask              = "${var.activeport3mask}"
    port4_ip                = "${var.activeport4}"
    port4_mask              = "${var.activeport4mask}"
    passive_peerip          = "${var.passiveport3}"
    mgmt_gateway_ip         = "${var.activeport4gateway}"
    defaultgwy      = "${var.primary_fortigate_private_ip_gateway}"
    privategwy      = "${var.primary_fortigate_secondary_private_ip_gateway}"
    vpc_ip          = cidrhost(var.hubvpc_vpc_cidr, 0)
    vpc_mask        = cidrnetmask(var.hubvpc_vpc_cidr)
    vpc_cidr_ack1      = "${var.ack1_node_pod_subnet}"
    vpc_cidr_ack2   = "${var.ack2_node_pod_subnet}"
    vpc_cidr_fortiadc    = "${var.fortiadc_subnet}"
    adminsport      = "${var.adminsport}"
    client_source_ip_subnet = "${var.client_source_ip_subnet}"
    admin_api_user = "${var.admin_api_user}"
    client_vm = "${var.client_vm_private_ip}"
    fortiadc_vm = "${var.fortiadc_vswitch_a_cidr_vswitch1_a_ip}"
  }
}


