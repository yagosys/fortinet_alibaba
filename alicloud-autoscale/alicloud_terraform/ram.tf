resource "alicloud_ram_role" "ram_role" {
    name = "${var.cluster_name}-Logging-Role-${random_string.random_name_post.result}"
    services = ["fc.aliyuncs.com"]
    description = "AutoScale Logging and describe vpc Role, created by Terraform"
    force = true
    depends_on = ["alicloud_ram_policy.policy", "alicloud_ram_policy.policy_vpc"]
}

resource "alicloud_ram_policy" "policy" {
    name = "${var.cluster_name}-Logging-Policy-${random_string.random_name_post.result}"
    depends_on = ["alicloud_log_project.AutoScaleLogging", "alicloud_log_store.AutoScaleLogging-Store"]
  document = <<EOF
{
"Statement": [
{
    "Action": "log:PostLogStoreLogs",
    "Effect": "Allow",
    "Resource" : "acs:log:*:*:project/${alicloud_log_project.AutoScaleLogging.name}/logstore/${alicloud_log_store.AutoScaleLogging-Store.name}"
}
],
"Version": "1"
}
EOF
    description = "FortiGate AutoScale Logging Policy"
    force = true
}

//The following Policy is required to allow the Function to join the VPC
resource "alicloud_ram_policy" "policy_vpc" {
    name = "${var.cluster_name}-function-vpc-policy-${random_string.random_name_post.result}"
  document = <<EOF
{
    "Version": "1",
    "Statement": [
        {
            "Action": [
                "vpc:DescribeVSwitchAttributes"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "vpc:DescribeHaVip*",
                "vpc:DescribeRouteTable*",
                "vpc:DescribeRouteEntry*",
                "vpc:DescribeVSwitch*",
                "vpc:DescribeVRouter*",
                "vpc:DescribeVpc*",
                "vpc:Describe*Cen*",
                "ecs:CreateNetworkInterface",
                "ecs:DescribeNetworkInterfaces",
                "ecs:CreateNetworkInterfacePermission",
                "ecs:DescribeNetworkInterfacePermissions",
                "ecs:DeleteNetworkInterface"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF

    description = "FortiGate AutoScale VPC Policy - Used to bind vpc to function compute during automated deploy"

    force = true
}
resource "alicloud_ram_role_policy_attachment" "attach"{
    policy_name = "${alicloud_ram_policy.policy.name}"
    policy_type = "${alicloud_ram_policy.policy.type}"
    role_name = "${alicloud_ram_role.ram_role.name}"
}
resource "alicloud_ram_role_policy_attachment" "attach_vpc"{
    policy_name = "${alicloud_ram_policy.policy_vpc.name}"
    policy_type = "${alicloud_ram_policy.policy_vpc.type}"
    role_name = "${alicloud_ram_role.ram_role.name}"
}
