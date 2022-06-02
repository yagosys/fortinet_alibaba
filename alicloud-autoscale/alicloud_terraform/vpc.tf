resource "alicloud_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}" //default is 172.16.0.0/16
    name = "${var.cluster_name}-${random_string.random_name_post.result}"
}

resource "alicloud_vswitch" "vsw" {
    vpc_id            = "${alicloud_vpc.vpc.id}"
    cidr_block        = "${var.vswitch_cidr_1}" //172.16.0.0/21 default
    availability_zone = "${data.alicloud_zones.default.zones.0.id}"
}
//zone B
resource "alicloud_vswitch" "vsw2" {
    vpc_id            = "${alicloud_vpc.vpc.id}"
    cidr_block        = "${var.vswitch_cidr_2}" //172.16.8.0/21 default
    availability_zone = "${data.alicloud_zones.default.zones.1.id}"
}
