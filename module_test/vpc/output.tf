output "vpc-id" {
 value=alicloud_vpc.vpc.id
}

output "sg-id" {
value = alicloud_security_group.SecGroup.*.id
}
