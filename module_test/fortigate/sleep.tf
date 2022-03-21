resource "time_sleep" "wait_60_seconds_after_create_primary_fortigate_interface3" {
 depends_on = [alicloud_network_interface.PrimaryFortiGateInterface3]
   create_duration = "30s"
}

resource "time_sleep" "wait_60_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "60s"
}

resource "time_sleep" "wait_30_seconds_after_create_internal_a_vswitch" {
 count= var.number_of_zone==0 ? (var.custom_rt==0 ? 0 : 1) : var.number_of_fortigate
 depends_on = [alicloud_vswitch.internal_a]
   create_duration =  "30s"
}
