resource "time_sleep" "wait_45_seconds_after_create_vswitch" {
   depends_on=[alicloud_vswitch.vsw_internal_B]
   create_duration =  "45s"
}

resource "time_sleep" "wait_45_seconds_after_create_vswitch_A" {
   depends_on=[alicloud_vswitch.vsw_internal_A]
   create_duration =  "45s"
}
