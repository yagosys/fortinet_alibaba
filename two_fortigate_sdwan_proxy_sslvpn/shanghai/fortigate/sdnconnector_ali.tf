resource "fortios_system_sdnconnector" "sdn_connector_aliyun_sdn" {
    name               = "china-aliyun-andywang"
    region             = "cn-beijing"
    status             = "enable"
    type               = "alicloud"
    update_interval    = 60
    use_metadata_iam   = "disable"
    access_key = "LTAI5t62YzQckDoC8hDMMP6x"
    secret_key = "TWH7YffdaDkpYgO4sLwKvUdQzdASae"
}
