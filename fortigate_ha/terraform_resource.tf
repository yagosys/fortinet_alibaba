resource "random_string" "psk" {
  length           = 16
  special          = true
  override_special = ""
}

resource "random_string" "random_name_post" {
  length           = 4
  special          = true
  override_special = ""
  min_lower        = 4
}



resource "time_sleep" "wait_180_seconds_after_create_Primary_fortigate" {
//this is for give fortigate to apply license and form HA before associate EIP
 depends_on = [alicloud_instance.PrimaryFortigate]
 count = var.num_secondary_instances=="1"? 1:0
 create_duration = "180s"
}

resource "time_sleep" "wait_60_seconds_after_create_custom_rt" {
  depends_on = [alicloud_route_table.custom_route_tables]

  create_duration = "60s"
}

resource "time_sleep" "wait_60_seconds_after_create_internal_b_vswitch" {
 depends_on = [alicloud_vswitch.internal_b]
   create_duration =  "60s"
}

resource "time_sleep" "wait_60_seconds_after_create_internal_a_vswitch" {
 depends_on = [alicloud_vswitch.internal_a_0]
   create_duration =  "60s"
}

resource "time_sleep" "wait_60_seconds_after_create_secondary_fortigate_interface3" {
 depends_on = [alicloud_network_interface.SecondaryFortiGateInterface3]
   create_duration = "60s"
}

resource "time_sleep" "wait_60_seconds_after_create_primary_fortigate_interface3" {
 depends_on = [alicloud_network_interface.PrimaryFortiGateInterface3]
   create_duration = "60s"
}
