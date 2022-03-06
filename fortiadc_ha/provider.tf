provider "alicloud" {
  profile = "andywang"
  //  profile = "default" //this is for aliyun international 
  region = var.region
}

provider "alicloud" {
  alias   = "wangxianping"
  profile = "18121219849"
  region  = "cn-shanghai"
}

variable "region" {
  type    = string
  default = "cn-hongkong" //Default Region
}

variable "ALIYUN__Region" {
  type = string
  default = "cn-hongkong"
}
