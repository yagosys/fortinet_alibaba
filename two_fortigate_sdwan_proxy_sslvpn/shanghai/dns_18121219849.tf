resource "alicloud_alidns_record" "myrecord" {
  provider =  alicloud.wangxianping
  domain_name = "computenest.top"
  rr          = "sh"
  type        = "A"
  ttl         = 60
  value       = alicloud_instance.PrimaryFortigate.public_ip
  remark      = "Test new alidns record."
  status      = "ENABLE"
}
