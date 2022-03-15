resource "alicloud_ram_role" "role" {
  name     = "Fortigate-HA-New-${random_string.random_name_post.result}"
  count    = var.iam != "Fortigate-HA-New" ? 1 : 0
  document = <<EOF
    { 
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": [
              "ecs.aliyuncs.com"
            ]
          }
        }
      ],
      "Version": "1"
    } 
EOF     

  description = "this is a role test."
  force       = true
}

//              
resource "alicloud_ram_policy" "policy" {
  name     = "Fortigate-HA-New-rule-${random_string.random_name_post.result}"
  count    = var.iam != "Fortigate-HA-New" ? 1 : 0
  document = <<EOF
    {           
      "Statement": [
        {       
          "Action": [
                "vpc:*",
                "vpc:*EipAddress*",
                "vpc:UntagResources",
                "vpc:TagResources",
                "vpc:*VSwitch*",
                "ecs:*",
                "eipanycast:*",
		"cen:*",
                "ecs:DescribeInstances",
                "vpc:DescribeVpcs",
                "vpc:DescribeVSwitches",
                "vpc:*Eip*",
                "vpc:*HighDefinitionMonitor*",
                "vpc:*HaVip*",
                "vpc:*RouteTable*",
                "vpc:*VRouter*",
                "vpc:*RouteEntry*",
                "vpc:*VSwitch*",
                "vpc:*Vpc*",
                "vpc:*Cen*",
                "vpc:*Tag*",
                "vpc:*NetworkAcl*",
                "ecs:*Instance*"
            
          ],
          "Effect": "Allow",
          "Resource": [
            "*"
          ]
        },
        {
                "Action": [
                "ecs:*"

            ],
            "Resource": "*",
            "Effect": "Allow"
        }
      ],
        "Version": "1"
    }
EOF

  description = "this is a policy test"
  force       = true
}
//


resource "alicloud_ram_role_policy_attachment" "fortigate_attach" {
  count       = var.iam !="Fortigate-HA-New" ? 1 : 0
  policy_name = alicloud_ram_policy.policy[0].name
  role_name   = alicloud_ram_role.role[0].name
  policy_type = alicloud_ram_policy.policy[0].type
}
