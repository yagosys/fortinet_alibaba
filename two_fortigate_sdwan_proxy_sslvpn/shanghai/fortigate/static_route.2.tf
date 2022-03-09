//terraform import fortios_router_static.static_route_to_cidr_via_ipsec_tunnel  1
resource "fortios_router_static" "static_route_to_cidr_via_ipsec_tunnel" {
  count = length(var.tunnel_info)-1

 device   = format("%s_%s", var.tunnel_name_prefix, count.index + 1)
//  distance = var.tunnel_info[count.index].tunnel_route_distance
  dst      = "1.1.1.1/32" //var.remote_cidr
//  priority = 0
  gateway = "169.254.100.1" 
  
  status   = "enable"

  depends_on = [
    fortios_vpnipsec_phase1interface.phase1,
    fortios_vpnipsec_phase2interface.phase2,
  ]
}

resource "fortios_router_static" "static_route_to_ipsec_tunnel_peer" {
  count = length(var.tunnel_info)-1

 device   = format("%s_%s", var.tunnel_name_prefix, count.index + 1)
  dst      = "169.254.100.1/32" //peer ipsec tunnel interface address
  gateway = "169.254.100.1"
  status   = "enable"
  depends_on = [
    fortios_vpnipsec_phase1interface.phase1,
    fortios_vpnipsec_phase2interface.phase2,
  ]
}

resource "fortios_router_static" "topeerfortigatepublicip" {
 device = "port1"
 dst = var.peer_fortigate_port1_publicip
 gateway = "10.0.11.253"
 status = "enable"
}

resource "fortios_router_static" "andy1" {
 device = "port1"
 dst = "119.3.33.95/32"
 gateway = "10.0.11.253"
 status = "enable"
}

resource "fortios_router_static" "andy2" {
 device = "port1"
 dst = "119.13.90.194/32"
 gateway = "10.0.11.253"
 status = "enable"
}

resource "fortios_router_static" "andy3" {
 device = "port1"
 dst = "101.231.169.226/32"
 gateway = "10.0.11.253"
 status = "enable"
}

resource "fortios_router_static" "andy4" {
 device = "port1"
 dst = "129.226.73.158/32"
 gateway = "10.0.11.253"
 status = "enable"
}
