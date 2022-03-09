resource "fortios_vpnssl_settings" "trsslvpnsetting" {
  port             = 18443
  default_portal   = "full-access"
  login_block_time = 60
  login_timeout    = 30
  servercert       = "self-sign"
  reqclientcert    = "disable"

  dns_server1                   = "1.1.1.1"
  dns_server2                   = "8.8.4.4"
  ssl_insert_empty_fragment     = "enable"
  ssl_max_proto_ver             = "tls1-3"
  ssl_min_proto_ver             = "tls1-2"
  transform_backward_slashes    = "disable"
  tunnel_connect_without_reauth = "disable"
  tunnel_user_session_timeout   = 30
  unsafe_legacy_renegotiation   = "disable"
  url_obscuration               = "disable"
  dtls_tunnel                   = "enable"
  wins_server1                  = "0.0.0.0"
  wins_server2                  = "0.0.0.0"
  x_content_type_options        = "enable"
  source_address {
    name = "all"
  }

  source_address6 {
    name = "all"
  }

  source_interface {
    name = "port1"
  }

  tunnel_ip_pools {
    name = "SSLVPN_TUNNEL_ADDR1"
  }

  tunnel_ipv6_pools {
    name = "SSLVPN_TUNNEL_IPv6_ADDR1"
  }
}
