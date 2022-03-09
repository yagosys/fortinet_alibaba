resource "fortios_firewall_vip" "sdn_serverloadbalancerwithdynamichost" {
    extintf                          = "port1"
    extip                            = "10.0.11.11"
    extport                          = "3389"
    ldb_method                       = "static"
    name                             = "rdp3389-win"
    protocol                         = "tcp"
    server_type                      = "tcp"
    type                             = "server-load-balance"
    realservers {
    port              = 3389
    status            = "active"
    address = fortios_firewall_address.sdn_rdphostviasg.name
    type              = "address"
  }
}
