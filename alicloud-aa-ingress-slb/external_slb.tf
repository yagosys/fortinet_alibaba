data "alicloud_slb_zones" "external_default" {
  available_slb_address_type       = "classic_internet"
  available_slb_address_ip_version = "ipv4"
}

resource "alicloud_slb_load_balancer" "external_default" {
    name                 = "${var.cluster_name}.EXT_SLB-${random_string.random_name_post.result}"
    address_type = "internet"
    internet_charge_type = "PayByTraffic"
    specification = "slb.s1.small"
    // AliCloud specific variables.
    master_zone_id       = "${data.alicloud_slb_zones.default.zones.0.id}"//first available zone
    slave_zone_id        = "${data.alicloud_slb_zones.default.zones.1.id}"//second available zone.
}

resource "alicloud_slb_acl" "external_acl" {
    name = "${var.cluster_name}-External-ACL-${random_string.random_name_post.result}"
    ip_version = "ipv4"
    entry_list {
        entry="10.10.10.0/24"
        comment="first"
    }
    entry_list {
        entry="168.10.10.0/24"
        comment="second"
    }
    entry_list {
        entry="172.10.10.0/24"
        comment="third"
    }
}

resource "alicloud_slb_listener" "external_tcp" {
    depends_on = [alicloud_slb_listener.external_tcp_web8080]
    load_balancer_id = "${alicloud_slb_load_balancer.external_default.id}"
    backend_port = 22
    frontend_port = 22
    health_check = "on"
    bandwidth = 100
    health_check_connect_port =22
    protocol = "tcp"
    sticky_session = "on" //Persistent session
    sticky_session_type = "server" //Fortigate Serves the cookie.
    cookie = "FortiGateAutoScaleSLB"
    cookie_timeout = 86400
    persistence_timeout = 3600
    acl_status                = "off"
    acl_type                  = "white"
    acl_id                    = "${alicloud_slb_acl.external_acl.id}"
    server_group_id = alicloud_slb_server_group.external_default.id
}

resource "alicloud_slb_listener" "external_tcp_web8080" {
    load_balancer_id = "${alicloud_slb_load_balancer.external_default.id}"
    backend_port = 8080
    frontend_port = 8080
    health_check = "on"
    bandwidth = 100
    health_check_connect_port =8080
    protocol = "tcp"
//    health_check_type = "http"
//    health_check_method = "get"
//    health_check_http_code    = "http_2xx,http_3xx"
//    health_check_uri = "/"
    sticky_session = "on" //Persistent session
    sticky_session_type = "server" //Fortigate Serves the cookie.
    cookie = "FortiGateAutoScaleSLBweb8080"
    cookie_timeout = 86400
    persistence_timeout = 3600
    acl_status                = "off"
    acl_type                  = "white"
    acl_id                    = "${alicloud_slb_acl.external_acl.id}"
    server_group_id = alicloud_slb_server_group.external_default_web8080.id
    x_forwarded_for {
    retrive_slb_ip = true
    retrive_slb_id = true
  }
}



resource "alicloud_slb_server_group" "external_default" {
  load_balancer_id = alicloud_slb_load_balancer.external_default.id
  name             = "external_somename"
}

resource "alicloud_slb_server_group_server_attachment" "external_default_ssh_primary" {
  server_group_id = alicloud_slb_server_group.external_default.id
  server_id       = alicloud_instance.PrimaryFortigate.id
  port            = 22
  weight          = 50
}

resource "alicloud_slb_server_group_server_attachment" "external_default_ssh_secondary" {
  server_group_id = alicloud_slb_server_group.external_default.id
  server_id       = alicloud_instance.SecondaryFortigate.id
  port            = 22
  weight          = 50
}

resource "alicloud_slb_server_group" "external_default_web8080" {
  load_balancer_id = alicloud_slb_load_balancer.external_default.id
  name             = "external_somename_web8080"
}
resource "alicloud_slb_server_group" "external_default_web8443" {
  load_balancer_id = alicloud_slb_load_balancer.external_default.id
  name             = "external_somename_web8443"
}

resource "alicloud_slb_server_group_server_attachment" "external_default_web8080_primary" {
  server_group_id = alicloud_slb_server_group.external_default_web8080.id
  server_id       = alicloud_instance.PrimaryFortigate.id
  port            = 8080
  weight          = 50
}

resource "alicloud_slb_server_group_server_attachment" "external_default_web8080_secondary" {
  server_group_id = alicloud_slb_server_group.external_default_web8080.id
  server_id       = alicloud_instance.SecondaryFortigate.id
  port            = 8080
  weight          = 50
}

resource "alicloud_slb_listener" "external_tcp_web8443" {
    depends_on=[alicloud_slb_listener.external_tcp]
    load_balancer_id = "${alicloud_slb_load_balancer.external_default.id}"
    backend_port = 8443
    frontend_port = 8443
    health_check = "on"
    bandwidth = 100
    health_check_connect_port =8443
    protocol = "tcp"
//    health_check_type = "http"
//    health_check_method = "get"
//    health_check_http_code    = "http_2xx,http_3xx"
//    health_check_uri = "/"
    sticky_session = "on" //Persistent session
    sticky_session_type = "server" //Fortigate Serves the cookie.
    cookie = "FortiGateAutoScaleSLB8443"
    cookie_timeout = 86400
    persistence_timeout = 3600
    acl_status                = "off"
    acl_type                  = "white"
    acl_id                    = "${alicloud_slb_acl.external_acl.id}"
    server_group_id = alicloud_slb_server_group.external_default_web8443.id
 //   x_forwarded_for {
 //   retrive_slb_ip = true
 //   retrive_slb_id = true
//  }
}

resource "alicloud_slb_server_group_server_attachment" "external_default_web8443_primary" {
  server_group_id = alicloud_slb_server_group.external_default_web8443.id
  server_id       = alicloud_instance.PrimaryFortigate.id
  port            = 8443
  weight          = 100
}

resource "alicloud_slb_server_group_server_attachment" "external_default_web8443_secondary" {
  server_group_id = alicloud_slb_server_group.external_default_web8443.id
  server_id       = alicloud_instance.SecondaryFortigate.id
  port            = 8443
  weight          = 100
}

output "externalslbipv4address" {
 value = alicloud_slb_load_balancer.external_default.address
}
