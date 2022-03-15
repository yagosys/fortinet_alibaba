output "ack2_worknode_ip" {
value = alicloud_cs_managed_kubernetes.k8s_ack2[0].worker_nodes[*].private_ip
}
