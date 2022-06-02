resource "alicloud_oss_bucket" "default" {
  bucket = var.ossBucketName
}

# If you upload the function by OSS Bucket, you need to specify path can't upload by content.
resource "alicloud_oss_bucket_object" "default" {
  bucket = alicloud_oss_bucket.default.id
  key    = "fc/alicloud-autoscale.zip"
  source = "../dist/alicloud-autoscale.zip"
}
