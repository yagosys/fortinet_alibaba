resource "fortios_webproxy_global" "webproxy_global" {
    fast_policy_match               = "enable"
    forward_proxy_auth              = "disable"
    forward_server_affinity_timeout = 30
    id                              = "webproxy_global"
    learn_client_ip                 = "disable"
    max_message_length              = 32
    max_request_length              = 8
    max_waf_body_cache_length       = 32
    proxy_fqdn                      = "default.fqdn"
    ssl_ca_cert                     = "Fortinet_CA_SSL"
    ssl_cert                        = "Fortinet_Factory"
    strict_web_check                = "disable"
}
