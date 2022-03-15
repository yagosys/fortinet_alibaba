resource "alicloud_ram_role" "fortiadcrole" {
  name     = "${random_string.random_name_post.result}-fortiadc"
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
resource "alicloud_ram_policy" "fortiadcpolicy" {
  name     = "${random_string.random_name_post.result}-fortiadc-rule"
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
                "ecs:*Instance*",
                "oss:*"
            
          ],
          "Effect": "Allow",
          "Resource": [
            "*"
          ]
        },
        {
                "Action": [
                 "ecs:*",
                 "oss:*"

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


resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = alicloud_ram_policy.fortiadcpolicy.name
  role_name   = alicloud_ram_role.fortiadcrole.name
  policy_type = alicloud_ram_policy.fortiadcpolicy.type
}
