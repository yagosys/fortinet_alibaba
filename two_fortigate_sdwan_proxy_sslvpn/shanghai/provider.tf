provider "alicloud" {
 // profile = "default"
  profile = "andywang"
  region  = var.region
}

provider "alicloud" {
  alias  = "wangxianping"
  profile = "18121219849"
  region = "cn-shanghai"
}

variable "region" {
  type    = string
  default = "cn-beijing" //Default Region
}


