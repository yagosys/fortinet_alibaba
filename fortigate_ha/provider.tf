provider "alicloud" {
	profile = var.account_region== "china" ? "andywang" : "default"
  	region  = var.region
}


