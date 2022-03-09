resource "null_resource" "scripts" {
  provisioner "local-exec" {

  interpreter = ["/bin/bash" ,"-c"]

  command = <<EOT
  echo ipaddress='"'${alicloud_instance.PrimaryFortigate.public_ip}'"' >ActiveFortigate.sh
  echo '[[ $(ping $ipaddress -w 1200 -c10) ]] && echo fortigate is reachable now || exit 1' >>ActiveFortigate.sh
  echo token=\`ssh -i mykey -oStrictHostKeyChecking=no admin\@${alicloud_instance.PrimaryFortigate.public_ip} execute api-user generate-key ${data.template_file.activeFortiGate.vars.admin_api_user}\` >>ActiveFortigate.sh
  echo tokenstring='`echo $token | cut -d " " -f6`' >>ActiveFortigate.sh
  echo 'echo $tokenstring' >>ActiveFortigate.sh
  echo adminsport='"'${data.template_file.activeFortiGate.vars.adminsport}'"' >>ActiveFortigate.sh
  echo 'export FORTIOS_ACCESS_HOSTNAME=$ipaddress:$adminsport' >>ActiveFortigate.sh
  echo 'export FORTIOS_ACCESS_TOKEN=$tokenstring' >>ActiveFortigate.sh
  echo 'export FORTIOS_INSECURE=true' >>ActiveFortigate.sh
  echo 'echo ipsec_peer_source=$ipaddress' >>ActiveFortigate.sh
  chmod +x ActiveFortigate.sh
  ip=`curl -s  ipinfo.io  | jq -r .ip`
  sed -i '/client_source_ip_subnet/d' terraform.tfvars
  echo client_source_ip_subnet=\"$ip/255.255.255.255\" >>terraform.tfvars
  EOT
  }
}
