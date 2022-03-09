resource "fortios_system_externalresource" "sdnconnector_externalresourcefromurl" {
    name                    = "allowediplist"
    resource                = "https://fortiweb-for-sap.oss-cn-hongkong.aliyuncs.com/ip.txt"
    source_ip               = "0.0.0.0"
    status                  = "enable"
    refresh_rate            = 5
    type                    = "address"
}
