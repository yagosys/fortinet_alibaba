provider "alicloud" {
  profile = "andywang"
//  profile = "default" //this is for aliyun international
  region  = var.region
}

provider "alicloud" {
  alias  = "wangxianping"
  profile = "18121219849"
  region = "cn-shanghai"
}

