resource "fortios_system_interface" "ipsec_auto_interface" {
 count = length(var.tunnel_info)-1
 name              = format("%s_%s", var.tunnel_name_prefix, count.index + 1)

  ip           = "169.254.101.2 255.255.255.255"
  allowaccess  = "ping"
  vdom         = "root"
  remote_ip    = "169.254.100.1 255.255.255.255"
  interface    = "port1"
  autogenerated = "auto"
depends_on = [fortios_vpnipsec_phase2interface.phase2[0]]
}
