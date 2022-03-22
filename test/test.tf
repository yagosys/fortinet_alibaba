variable subnet_cidr {
 default= "10.0.0.0/16"
}

variable number_of_zone {
 default =1
}

locals {
cidr_block = {
                external = [
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,11) : cidrsubnet(var.subnet_cidr,8,11),
			var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,21) : cidrsubnet(var.subnet_cidr,8,11),
                ]
                internal = [
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,12) : cidrsubnet(var.subnet_cidr,8,12),
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,22) : cidrsubnet(var.subnet_cidr,8,12),
                ]
                ha = [
                        var.number_of_zone==2 ?  cidrsubnet(var.subnet_cidr,8,13) :  cidrsubnet(var.subnet_cidr,8,13),
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,23) :  cidrsubnet(var.subnet_cidr,8,13),
                ]
                mgmt = [
                        var.number_of_zone==2 ?  cidrsubnet(var.subnet_cidr,8,14) :  cidrsubnet(var.subnet_cidr,8,14), 
                        var.number_of_zone==2 ? cidrsubnet(var.subnet_cidr,8,24) :  cidrsubnet(var.subnet_cidr,8,14),
                ]
                internal_cidr = [
                        "10.0.0.0/16"
                ]
}
}
output "test" {
value= local.cidr_block["external"]
}
output "a2" {
value= local.cidr_block["internal"]
}
output "a3" {
value= local.cidr_block["ha"]
}
output "a4" {
value= local.cidr_block["mgmt"]
}
