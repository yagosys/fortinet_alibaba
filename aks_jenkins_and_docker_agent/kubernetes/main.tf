resource "alicloud_security_group" "SecGroup" {
  vpc_id      = alicloud_vpc.default.id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress_ack1" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup.id
  cidr_ip           = "0.0.0.0/0"
}


// Instance_types data source for instance_type
data "alicloud_instance_types" "default" {
  cpu_core_count = "${var.cpu_core_count}"
  memory_size    = "${var.memory_size}"
}

// Zones data source for availability_zone
data "alicloud_zones" "default" {
  available_instance_type = "${var.worker_instance_type == "" ? data.alicloud_instance_types.default.instance_types.0.id : var.worker_instance_type}"
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "default" {
  vpc_name = var.example_name
  cidr_block = "10.1.0.0/21"
}

resource "alicloud_vswitch" "default" {
  vswitch_name = var.example_name
  vpc_id = alicloud_vpc.default.id
  cidr_block = "10.1.1.0/24"
  zone_id = data.alicloud_zones.default.zones[0].id
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  count                 = 1
  name                  = "${var.k8s_name_prefix == "" ? format("%s-%s", var.example_name, format(var.number_format, count.index+1)) : format("%s-%s", var.k8s_name_prefix, format(var.number_format, count.index+1))}"
  availability_zone     = data.alicloud_zones.default.zones[0].id
  worker_vswitch_ids = [alicloud_vswitch.default.id]
  new_nat_gateway       = true
  worker_instance_types = ["${var.worker_instance_type == "" ? data.alicloud_instance_types.default.instance_types.0.id : var.worker_instance_type}"]
  worker_number         = "${var.k8s_worker_number}"
  worker_disk_category  = "${var.worker_disk_category}"
  worker_disk_size      = "${var.worker_disk_size}"
  password              = "${var.ecs_password}"
  pod_cidr              = "${var.k8s_pod_cidr}"
  service_cidr          = "${var.k8s_service_cidr}"
  slb_internet_enabled  = true
  install_cloud_monitor = false
  kube_config           = "~/.kube/config"
  security_group_id = alicloud_security_group.SecGroup.id
}
