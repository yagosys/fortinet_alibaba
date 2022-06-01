data "alicloud_slb_zones" "default" {
  available_slb_address_type       = "classic_internet"
  available_slb_address_ip_version = "ipv4"
}

resource "alicloud_slb_load_balancer" "default" {
    name                 = "${var.cluster_name}.SLB-${random_string.random_name_post.result}"
    address_type = "intranet"
    internet_charge_type = "PayByTraffic"
    specification = "slb.s1.small"
    vswitch_id         = alicloud_vswitch.vsw_internal_A.id
    // AliCloud specific variables.
    master_zone_id       = "${data.alicloud_slb_zones.default.zones.0.id}"//first available zone
    slave_zone_id        = "${data.alicloud_slb_zones.default.zones.1.id}"//second available zone.
    address=var.slb_private_ip
}

resource "alicloud_slb_acl" "acl" {
    name = "${var.cluster_name}-Internal-ACL-${random_string.random_name_post.result}"
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
    load_balancer_id = "${alicloud_slb_load_balancer.default.id}"
    backend_port = 8080
    frontend_port = 8080
    health_check = "on"
    bandwidth = 100
    health_check_connect_port = 8080
    health_check_type = "http"
    health_check_method = "get"
    health_check_http_code    = "http_2xx,http_3xx"
    health_check_uri = "/"
    protocol = "tcp"
    sticky_session = "on" //Persistent session
    sticky_session_type = "server" //Fortigate Serves the cookie.
    cookie = "FortiGateAutoScaleSLB"
    cookie_timeout = 86400
    persistence_timeout = 3600
    acl_status                = "off"
    acl_type                  = "white"
    acl_id                    = "${alicloud_slb_acl.acl.id}"
    server_group_id = alicloud_slb_server_group.default.id
    x_forwarded_for {
    retrive_slb_ip = true
    retrive_slb_id = true
  }
}

resource "alicloud_slb_server_group" "default" {
  load_balancer_id = alicloud_slb_load_balancer.default.id
  name             = "somename"
}

resource "alicloud_slb_server_group_server_attachment" "default" {
  count           = var.number_web_vm
  server_group_id = alicloud_slb_server_group.default.id
  server_id       = alicloud_instance.web-a[count.index].id
  port            = 8080
  weight          = 100
}


output "intra_slb_name" {
 value = alicloud_slb_load_balancer.default.name
}
