ipaddress=$(host hk.computenest.top | grep address | cut -d ' ' -f 4)
sed -i "s/default=.*fortigate/default=\"$ipaddress\/32\" \/\/fortigate/g" variables.tf
terraform apply -auto-approve
