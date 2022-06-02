output "PSK_Secret" {
    value = "${random_string.psk.result}"
}
output "Auto_Scaling_Group_ID" {
    value = "${alicloud_ess_scaling_group.scalinggroups_ds.id}"
}
output "VPC_name" {
    value = "${alicloud_vpc.vpc.name}"
}
output "Scale_Out_Threshold" {
    value = "${var.scale_out_threshold}"
}
output "Scale_In_Threshold" {
    value = "${var.scale_in_threshold}"
}
output "AutoScale_External_Load_Balancer_IP" {
    value = "${alicloud_slb.default.address}"
}

output "Access_webserver_via_slb" {
   value = var.number_web_vm !=0 ? "curl -v http://${alicloud_slb.default.address}:8080" : null
}

output "Access_webserver_via_slb_ssh" {
value = var.number_web_vm !=0 ? "ssh root@${alicloud_slb.default.address} -p 8022" : null 
}
