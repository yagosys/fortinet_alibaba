please follow https://github.com/yagosys/fortinet_alibaba/blob/main/securehub_ack/Secure%20ACK%20with%20Fortigate%20and%20FortiADC.pdf for POC setup and configuration.


Prerequisition
1. Fortigate BYOL license , contact fortinet to obtain BYOL license
2. FortiADC BYOL License, contact fortinet to obtain BYOL license
3. FortiADC custom image, contact fortinet to obtain fortiadc image and build custom image on alibaba in the target region
4. CEN support, contact alibaba to whitelist CEN subnet routing feature for the target region

Procedure to deploy
1. the default configuration use alibaba china account. the default variable is in cn.auto.tfvars. 
2. modify the cn.auto.tfvars  with proper license and image id,region etc

here is the explaination of variable

instance_ami="m-j6cj2liju58d88zmgbdg" //fortigate hongkong china 6.4 version image

fortiadc_instance_ami="m-j6cci77g4mwuaa8xfkx7" //custom image 6.0.1 on region hongkong

fadlicense="./fadv040000225874.lic" //fortiadc license, please put in the same directory with terraform script.

zone_id_1="cn-hongkong-b" //this is the zone that CEN has attachment support,different region has different zone id region

zone_id_2="cn-hongkong-c" //this is the zone that CEN has attachment support

region="cn-hongkong"

ALIYUN__region="cn-hongkong" //this is not required. reserved  

cen_region="cn-hongkong" //this is the CEN region, must be same region as other VPCs in this POC.

activefgtlicense="./FGVMULTM22000750.lic" //fortigate license, place in the same directory with terraform script.
fortiadcpublicip_bandwidth_out="5"  //this is for fortiadc public ip, if not required, use "0".


3. deployment
terraform apply 


after deployment, it shall output below information.

Outputs:

FortigateAdminGUI_PORT = "8443"

PrimaryFortigateAvailability_zone = "cn-hongkong-b"

PrimaryFortigateID = "i-j6c8ukmv8inb7eul5ik5"

PrimaryFortigatePrivateIP = "192.168.11.11"

PrimaryFortigatePublicIP = "47.242.124.76"

PrimaryFortigateport2IP = "192.168.12.11"

ack1_worknode_ip = tolist([

  "10.1.0.164",
  
  "10.1.0.163",
])

ack2_worknode_ip = tolist([

  "10.0.0.250",
  
  "10.0.0.251",
])

client-vm = "192.168.12.60"

client-vm-password = "Welcome.123"

client-vm-ssh-port = "2022"

fortiadc_gui_https_port = 9443

fortiadc_instance_id = "i-j6c8ukmv8inb7eul5ik6"

fortiadc_private_ip = "10.0.11.11"

fortiadc_public_ip = "47.243.181.129"

fortiadc_ssh_port = 6022



after deployment.

fortiadc cloud init is currently not working, so please activiate fortiadc license and config fortiadc manually. 
fortiadc license can be activied by GUI or by below method.

the fortiadc license file has been uploaded to tftp server  192.168.12.60 (you client machine ip) already. 
so login into fortiadc and do 
FortiADC-ALI # execute vm license tftp FADLICENSE.lic 192.168.12.60

the next, you will need to config fortiadc k8s connector and L7 ingress for nginx service on both ACK. please follow userguide.


