resource "alicloud_slb" "default" {
    name                 = "${var.cluster_name}.SLB-${random_string.random_name_post.result}"
//    address_type = "internet"
    internet = true //for old version
    internet_charge_type = "PayByTraffic"
    bandwidth            = 5
    specification = "slb.s1.small"
    // AliCloud specific variables.
    master_zone_id       = "${data.alicloud_slb_zones.default.zones.0.id}"//first available zone
    slave_zone_id        = "${data.alicloud_slb_zones.default.zones.1.id}"//second available zone.
}
resource "alicloud_slb_acl" "acl" {
    name = "${var.cluster_name}-ACL-${random_string.random_name_post.result}"
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
resource "alicloud_slb_listener" "http" {
    load_balancer_id = "${alicloud_slb.default.id}"
    backend_port = 8080
    frontend_port = 8080
    health_check = "on"
    bandwidth = 100
    health_check_connect_port = 8080
    protocol = "tcp"
    sticky_session = "on" //Persistent session
    sticky_session_type = "server" //Fortigate Serves the cookie.
    cookie = "FortiGateAutoScaleSLB"
    cookie_timeout = 86400
    persistence_timeout = 3600
    acl_status                = "off"
    acl_type                  = "white"
    acl_id                    = "${alicloud_slb_acl.acl.id}"
}

resource "alicloud_slb_listener" "ssh" {
    load_balancer_id = "${alicloud_slb.default.id}"
    backend_port = 8022
    frontend_port = 8022
    health_check = "on"
    bandwidth = 100
    health_check_connect_port = 8022
    protocol = "tcp"
    sticky_session = "on" //Persistent session
    sticky_session_type = "server" //Fortigate Serves the cookie.
    cookie = "FortiGateAutoScaleSLBwebssh"
    cookie_timeout = 86400
    persistence_timeout = 3600
    acl_status                = "off"
    acl_type                  = "white"
    acl_id                    = "${alicloud_slb_acl.acl.id}"
}
