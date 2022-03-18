variable "account_region" {
 type = string
 default = "china"
}

variable "zone_id_1" {
 type =string
 default = "cn-hongkong-b"
}

variable "zone_id_2" {
  type = string
  default = "cn-hongkong-c"
}

variable "region" {
  type = string
  default ="cn-hongkong"
}

variable "ALIYUN__region" {
  type    = string
  default = "cn-hongkong" //Default Region
}

variable "cen_region" {
  default = "cn-hongkong"
}

variable "client_vm_password" {
  type = string
  default = "Welcome.123"
}

variable "client_vm_username" {
  type = string
  default = "root"
}

variable "client_vm_instance_type" {
   type = string
   default = "ecs.hfc6.large"
}

variable "create_client_vm" {
  default="1"
}

variable "client_vm_ssh_port" {
   type = string 
   default = "2022"
}

variable "client_vm_internet_max_bandwidth_out" {
   type = string
   default = "0"
}

