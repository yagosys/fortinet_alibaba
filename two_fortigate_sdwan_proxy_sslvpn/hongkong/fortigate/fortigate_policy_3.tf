resource "fortios_firewall_policy" "from_ipsec_to_port1" {
  count = length(var.tunnel_info)-1
  action   = "accept"
  nat      = "enable"
  status   = "enable"
  schedule = "always"

  name = format("from_%s_%s", var.tunnel_name_prefix, count.index + 1)
  srcintf {
    name = format("%s_%s", var.tunnel_name_prefix, count.index + 1)
  }

  dstintf {
    name = "port1"
  }
  srcaddr {
    name = "all"
  }

  dstaddr {
    name = "all"
  }

  service {
    name = "ALL"
  }

  depends_on = [
    fortios_vpnipsec_phase1interface.phase1,
    fortios_vpnipsec_phase2interface.phase2,
  ]
}
