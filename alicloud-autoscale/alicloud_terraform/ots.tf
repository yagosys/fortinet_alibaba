// Create an OTS instance
resource "alicloud_ots_instance" "tablestore" {
    name = "FortiGateASG-${random_string.random_name_post.result}" //16 char limit
    description = "TableStore Instance Terraform"
    accessed_by = "Any"
    instance_type = "${var.table_store_instance_type}"
    tags = {
        Created = "TF"
        For = "FortiGate AutoScale Table"
    }
}
//Create the Tables
//While not neccessary, we create them here to allow terraform to destroy/manage them
//If they are not created during the terraform apply, they will be created by the function
resource "alicloud_ots_table" "table_FortiAnalyzer" {
    instance_name = "${alicloud_ots_instance.tablestore.name}"
    table_name = "FortiAnalyzer"
    primary_key  {
            name = "instanceId"
            type = "String"
        }

    time_to_live = "-1"
    max_version = "1"

}
resource "alicloud_ots_table" "table_FortiGateLifecycleItem" {
    instance_name = "${alicloud_ots_instance.tablestore.name}"
    table_name = "FortiGateLifecycleItem"
    primary_key {
            name = "instanceId"
            type = "String"
        }
    time_to_live = "-1"
    max_version = "1"

}
resource "alicloud_ots_table" "table_FortiGateMainElection" {
    instance_name = "${alicloud_ots_instance.tablestore.name}"
    #TODO: change to FortiGateMainElection, requires DB Change.
    table_name = "FortiGateMasterElection"
    primary_key  {
            name = "asgName"
            type = "String"
        }
    time_to_live = "-1"
    max_version = "1"

}
resource "alicloud_ots_table" "table_Settings" {
    instance_name = "${alicloud_ots_instance.tablestore.name}"
    table_name = "Settings"
    primary_key   {
            name = "settingKey"
            type = "String"
        }
    time_to_live = "-1"
    max_version = "1"
}
resource "alicloud_ots_table" "table_FortiGateAutoscale" {
    instance_name = "${alicloud_ots_instance.tablestore.name}"
    table_name = "FortiGateAutoscale"
    primary_key  {
            name = "instanceId"
            type = "String"
        }
    time_to_live = "-1"
    max_version = "1"
}
