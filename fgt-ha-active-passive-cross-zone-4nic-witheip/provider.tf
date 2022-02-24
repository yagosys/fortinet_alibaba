provider "alicloud" {
  profile = "default"
  region  = var.region
}
terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.157.0"
    }
  }
}


