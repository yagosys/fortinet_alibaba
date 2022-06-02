resource "alicloud_ess_scaling_group" "scalinggroups_ds" {
    // Autoscaling Group
    depends_on = ["alicloud_slb_listener.http"]
    scaling_group_name = "${var.cluster_name}-${random_string.random_name_post.result}"
    min_size           = 2
    max_size           = 3
    removal_policies   = ["OldestInstance", "NewestInstance"]
    vswitch_ids = ["${alicloud_vswitch.vsw.id}", "${alicloud_vswitch.vsw2.id}"]
    multi_az_policy = "BALANCE"
    loadbalancer_ids = [
    "${alicloud_slb.default.id}"
    ]
}
//Scaling Config


resource "alicloud_ess_scaling_configuration" "config" {
    force_delete = true
    scaling_group_id  = "${alicloud_ess_scaling_group.scalinggroups_ds.id}"
    image_id          = "${length(var.instance_ami) > 1 ? var.instance_ami : data.alicloud_images.ecs_image.images.0.id}"//grab the first image that matches the regex
    instance_type     = "${data.alicloud_instance_types.types_ds.instance_types.0.id}"//Grab the first instance that meets the requirements. Default 2 Cpu 8GB memory.
    security_group_id = "${alicloud_security_group.SecGroup.id}"
    internet_charge_type = "PayByTraffic"
    active = true
    enable = true
    user_data = "{'config-url':'https://${data.alicloud_account.current.id}.${var.region}-internal.fc.aliyuncs.com/2016-08-15/proxy/${alicloud_fc_service.fortigate-autoscale-service.name}/${alicloud_fc_function.fortigate-autoscale.name}/'}"
    depends_on = ["alicloud_fc_service.fortigate-autoscale-service","alicloud_fc_function.fortigate-autoscale","alicloud_fc_trigger.httptrigger","alicloud_oss_bucket_object.object-content","alicloud_ots_instance.tablestore"]
    internet_max_bandwidth_in = 200
    internet_max_bandwidth_out = 100
    data_disk  {
        size = 30
        category = "cloud_ssd"
        delete_with_instance = true
}
}

//Scaling Rule
//Scale Out
resource "alicloud_ess_scaling_rule" "scale_out" {
    scaling_group_id = "${alicloud_ess_scaling_group.scalinggroups_ds.id}"
    scaling_rule_name = "ScaleOut"
    adjustment_type  = "QuantityChangeInCapacity"
    adjustment_value = 1
    cooldown         = 60
}
//Scale In
resource "alicloud_ess_scaling_rule" "scale_in" {
    scaling_group_id = "${alicloud_ess_scaling_group.scalinggroups_ds.id}"
    scaling_rule_name = "ScaleIn"
    adjustment_type  = "QuantityChangeInCapacity"
    adjustment_value = -1
    cooldown         = 60
}
//Scaling Alarm
//Scale Out
resource "alicloud_ess_alarm" "cpu_alarm_scale_out" {
    name = "Fortigate_cpu_alarm_scale_out__${random_string.random_name_post.result}"
    description = "FortiGate AutoScaleCPU utilization alert"
    //Ari is the unique identifier for a scaling rule
    alarm_actions = ["${alicloud_ess_scaling_rule.scale_out.ari}"]
    scaling_group_id = "${alicloud_ess_scaling_group.scalinggroups_ds.id}"
    metric_type = "system"
    metric_name = "CpuUtilization"
    //Average over 300 seconds - only supports 60/120/300/900
    period = 300
    statistics = "Average"
    threshold = "${var.scale_out_threshold}"
    comparison_operator = ">="
    evaluation_count = 3
}

//Scale In
resource "alicloud_ess_alarm" "cpu_alarm_scale_in" {
    name = "Fortigate-cpu_alarm_scale_in_${random_string.random_name_post.result}"
    description = "FortiGate AutoScaleCPU utilization alert"
    //Ari is the unique identifier for a scaling rule
    alarm_actions = ["${alicloud_ess_scaling_rule.scale_in.ari}"]
    scaling_group_id = "${alicloud_ess_scaling_group.scalinggroups_ds.id}"
    metric_type = "system"
    metric_name = "CpuUtilization"
    //Average over 900 seconds - only supports 60/120/300/900
    period = 900
    statistics = "Average"
    threshold = "${var.scale_in_threshold}"
    comparison_operator = "<="
    evaluation_count = 3
}
