data "template_file" "setupPrimary" {
  template = "${file("${path.module}/assets/configset/baseconfig")}"
  vars = {
    region = "${var.region}",
    type = "${var.licensetype}",
}
}
