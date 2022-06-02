resource "alicloud_log_project" "AutoScaleLogging" {
    name        = "fortigateautoscalelog-${random_string.random_name_post.result}" //Name must be lower case
    description = "created by terraform"
}

resource "alicloud_log_store" "AutoScaleLogging-Store" {
    project               = "${alicloud_log_project.AutoScaleLogging.name}"
    name                  = "autoscalelog-store-${random_string.random_name_post.result}"
    shard_count           = 3
    auto_split            = true
    max_split_shard_count = 60
    append_meta           = true
    retention_period = 15
}
resource "alicloud_log_store_index" "log_store_index" {
    project = "${alicloud_log_project.AutoScaleLogging.name}"
    logstore = "${alicloud_log_store.AutoScaleLogging-Store.name}"
    full_text {
    case_sensitive = true
    token = " #$%^*\r\n\t"
      }
    field_search {
            name = "${alicloud_fc_function.fortigate-autoscale.name}"
            enable_analytics = true
        }
}
