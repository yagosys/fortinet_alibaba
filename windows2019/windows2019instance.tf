resource "alicloud_instance" "windowsInstance" {
  depends_on =[alicloud_security_group_rule.allow_all_icmp_ingress]
  availability_zone = data.alicloud_zones.default.zones.0.id
  image_id          = var.instance_ami

  instance_type = var.instance !="auto" ? var.instance : data.alicloud_instance_types.types_ds.instance_types.0.id

  system_disk_size           = 60
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "windows2019"
  system_disk_description    = "windows2019_system_disk"
  internet_max_bandwidth_out = 10
  password=var.password
  host_name=var.host_name
  security_groups   = alicloud_security_group.SecGroup.*.id
#  user_data = filebase64("${var.cloud_init_file}")
    user_data = <<EOF
<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  # Set Administrator password
  $admin = [adsi]("WinNT://./administrator, user")
  $admin.psbase.invoke("SetPassword", "${var.password}")
  
</powershell>
EOF


data_disks {
    name        = "disk2"
    size        = 20
    category    = "cloud_efficiency"
    description = "disk2"
  }

  instance_name              = "${var.instance_name}-${random_string.random_name_post.result}"
  vswitch_id                 = alicloud_vswitch.vswitch1_a.id
  private_ip = var.vswitch_a_cidr_vswitch1_a_ip
  tags = {
    Name = "terraform_created"
  }

    # Auto-Login's required to configure WinRM

 #connection {
 #   host     = alicloud_instance.windowsInstance.public_ip
 #   type     = "winrm"
 #   port     = 5985
 #   https    = false
 #   timeout  = "10m"
 #   user     = var.username
 #   password = var.password
 # }

 # provisioner "file" {
 #   source      = "files/config.ps1"
 #   destination = "c:/terraform/config.ps1"
 # }

}

