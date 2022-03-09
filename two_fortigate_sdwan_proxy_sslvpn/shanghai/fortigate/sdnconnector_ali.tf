resource "fortios_system_sdnconnector" "sdn_connector_aliyun_sdn" {
    name               = "china-aliyun-andywang"
    region             = "cn-beijing"
    status             = "enable"
    type               = "alicloud"
    update_interval    = 60
    use_metadata_iam   = "disable"
    access_key = ""
    secret_key = ""
}
