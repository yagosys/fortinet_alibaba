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

resource "time_sleep" "wait_360_seconds" {

  create_duration = "360s"
}


resource "time_sleep" "wait_120_seconds" {
  depends_on = [alicloud_vswitch.internal_a_0]

  create_duration = "120s"
}

resource "time_sleep" "wait_60_seconds_after_create_custom_rt" {
  depends_on = [alicloud_route_table.custom_route_tables]

  create_duration = "60s"
}

