data "alicloud_regions" "current_region_ds" {
    current = true
}
data "alicloud_zones" "default" {}
data "alicloud_slb_zones" "default" {
  available_slb_address_type       = "classic_internet"
  available_slb_address_ip_version = "ipv4"
}
