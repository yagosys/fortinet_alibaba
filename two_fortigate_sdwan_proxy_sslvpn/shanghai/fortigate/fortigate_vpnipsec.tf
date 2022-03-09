resource "fortios_vpnipsec_phase1interface" "phase1" {
  count = length(var.tunnel_info)-1

  name              = format("%s_%s", var.tunnel_name_prefix, count.index + 1)
  type 		    = "ddns"
  remotegw_ddns     = "hk.computenest.top"
  peertype          = "any"
  net_device        = "disable"
  proposal          = "aes128-sha256 aes256-sha256 aes128-sha1 aes256-sha1"
  nattraversal      = "forced"
  dpd               = "on-idle"
  dpd_retryinterval = "60"
  authmethod        = "psk"
  psksecret         = var.tunnel_info[count.index].tunnel_psk
  interface         = var.fortigate_interface
}

resource "fortios_vpnipsec_phase2interface" "phase2" {
  count = length(fortios_vpnipsec_phase1interface.phase1)

  name           = fortios_vpnipsec_phase1interface.phase1[count.index].name
  phase1name     = fortios_vpnipsec_phase1interface.phase1[count.index].name
  proposal       = "aes128-sha1 aes256-sha1 aes128-sha256 aes256-sha256 aes128gcm aes256gcm chacha20poly1305"
}
