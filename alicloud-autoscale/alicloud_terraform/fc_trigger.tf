//Function Compute Trigger
resource "alicloud_fc_trigger" "httptrigger" {
    service = alicloud_fc_service.fortigate-autoscale-service.name
    function = alicloud_fc_function.fortigate-autoscale.name
    name = "HTTPTrigger"
    type = "http"
    config = <<EOF
        {
            "methods": ["GET","POST"],
            "authType": "anonymous",
            "sourceConfig": {
                "project": "project-for-fc",
                "logstore": "project-for-fc"
            },
            "jobConfig": {
                "maxRetryTime": 3,
                "triggerInterval": 200
            },
            "functionParameter": {
                "a": "b",
                "c": "d"
            },
            "logConfig": {
                "project": "${alicloud_log_project.AutoScaleLogging.name}",
                "logstore": "${alicloud_log_store.AutoScaleLogging-Store.name}"
            },
            "enable": true
        }
    EOF

}
