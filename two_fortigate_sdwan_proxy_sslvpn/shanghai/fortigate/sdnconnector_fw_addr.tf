resource "fortios_firewall_address" "sdn_rdphostviasg" {
    filter        = "RegionId=cn-beijing | TagValue=FortiGate-Terraform"
    name          = "rdphost"
    obj_type      = "ip"
    sdn           = fortios_system_sdnconnector.sdn_connector_aliyun_sdn.name
    sdn_addr_type = "private"
    sub_type      = "sdn"
    type          = "dynamic"
}
