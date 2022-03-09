resource "fortios_router_static" "static_route_to_ipsec_tunnel_peer" {
  count = length(var.tunnel_info)-1
  device   = format("%s_%s", var.tunnel_name_prefix, count.index + 1)
  dst      = "169.254.101.2/32" //peer ipsec tunnel interface address
  gateway = "169.254.101.2"
  status   = "enable"
  depends_on = [
    fortios_vpnipsec_phase1interface.phase1,
    fortios_vpnipsec_phase2interface.phase2,
  ]
}

resource "fortios_router_static" "topeerfortigatepublicip" {
 device = "port1"
 dst = var.peer_fortigate_port1_publicip
 gateway = "192.168.11.253"
 status = "enable"
}

