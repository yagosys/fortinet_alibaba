
//OSS
resource "alicloud_oss_bucket" "FortiGateAutoScaleConfig" {
    bucket = "${var.bucket_name}-${random_string.random_name_post.result}" //Must be in lower case.
    acl = "private"
}

resource "alicloud_oss_bucket_object" "object-content" {
    bucket = "${alicloud_oss_bucket.FortiGateAutoScaleConfig.bucket}"
    key    = "baseconfig"
    source = "./assets/configset/baseconfig"
}

//Create the Function Service
resource "alicloud_fc_service" "fortigate-autoscale-service" {
    depends_on = ["alicloud_ram_role.ram_role"]
    name = "${var.cluster_name}-${random_string.random_name_post.result}" //Removed "service" from name to keep URL under 127 characters.
    description = "Created by terraform"
    internet_access = true
    role = "${alicloud_ram_role.ram_role.arn}"
    log_config {
            project = "${alicloud_log_project.AutoScaleLogging.name}"
            logstore = "${alicloud_log_store.AutoScaleLogging-Store.name}"
        }
    //ENI vswitch attachment:
    //Function Compute runs in the VPC.
    //The Indonesia Region requires this attachment in zone b whereas others require it in zone a
    vpc_config {
            vswitch_ids = ["${var.region == "ap-southeast-5" ? alicloud_vswitch.vsw2.id : alicloud_vswitch.vsw.id}"]
            security_group_id  = "${alicloud_security_group.SecGroup_FC.id}"
        }
}
//Function
resource "alicloud_fc_function" "fortigate-autoscale" {
    service = "${alicloud_fc_service.fortigate-autoscale-service.name}"
    name = "FortiGateASG-${random_string.random_name_post.result}"
    description = "FortiGate AutoScale - AliCloud Created by Terraform"
 //   filename = "../dist/alicloud-autoscale.zip"
    oss_bucket  = alicloud_oss_bucket.default.id
  oss_key     = alicloud_oss_bucket_object.default.key
    memory_size = "512"
    runtime = "nodejs8"
    handler = "index.handler"
    timeout = "1500"
    environment_variables = {
        managedby = "Created with Terraform"
        FORTIGATE_PSKSECRET = "${random_string.psk.result}"
        REGION_ID = "${var.region}"
        ENDPOINT_ESS = "https://ess.aliyuncs.com"
        ENDPOINT_ECS = "https://ecs.aliyuncs.com"
        ACCESS_KEY_SECRET = "${var.secret_key}"
        ACCESS_KEY_ID = "${var.access_key}"
        OSS_ENDPOINT = "oss-${var.region}.aliyuncs.com"
        BUCKET_NAME =  "${alicloud_oss_bucket.FortiGateAutoScaleConfig.bucket}"
        REGION_ID_OSS = "oss-${var.region}"
        CLIENT_TIMEOUT = 3000 //default
        DEFAULT_HEART_BEAT_INTERVAL = 10
        HEART_BEAT_DELAY_ALLOWANCE = 25000
        SCRIPT_EXECUTION_EXPIRE_TIME = 350000
        SCRIPT_TIMEOUT = 500
        TABLE_STORE_END_POINT ="https://${alicloud_ots_instance.tablestore.name}.${var.region}.ots.aliyuncs.com"
        TABLE_STORE_INSTANCENAME ="${alicloud_ots_instance.tablestore.name}"
        AUTO_SCALING_GROUP_NAME="${alicloud_ess_scaling_group.scalinggroups_ds.scaling_group_name}"
        BASE_CONFIG_NAME="baseconfig"
        FORTIGATE_ADMIN_PORT = 8443
    }
}



