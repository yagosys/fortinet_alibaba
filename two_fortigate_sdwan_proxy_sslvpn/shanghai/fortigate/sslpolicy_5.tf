resource "fortios_firewall_policy" "sslvpnpolicy" {
count = length(var.tunnel_info)-1
  action   = "accept"
  nat      = "enable"
  status   = "enable"
  logtraffic                  = "all"
  schedule = "always"

  name = "abc"
   srcintf {
        name = "ssl.root"
    }

  dstintf {
    name = format("%s_%s", var.tunnel_name_prefix, count.index + 1)
    //name = "port1"
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

  users {
        name = "cbc"
    }


depends_on = [
  fortios_vpnssl_settings.trsslvpnsetting
  ]
}
