Prerequisition
1. Fortigate BYOL license , contact fortinet to obtain BYOL license
2. FortiADC BYOL License, contact fortinet to obtain BYOL license
3. FortiADC custom image, contact fortinet to obtain fortiadc image and build custom image on alibaba in the target region
4. CEN support, contact alibaba to whitelist CEN subnet routing feature for the target region

Procedure to deploy
1. modify the cn.auto.tfvars  with proper license and image id,region etc

instance_ami="m-j6cj2liju58d88zmgbdg" //fortigate hongkong china

fortiadc_instance_ami="m-j6cci77g4mwuaa8xfkx7"

fadLicense="./FADV040000225874.lic"

zone_id_1="cn-hongkong-b"

zone_id_2="cn-hongkong-c"

region="cn-hongkong"

ALIYUN__region="cn-hongkong"

cen_region="cn-hongkong"

fgtlicense="./FGVMULTM22000750.lic"

change the region to your own region, place both fortigate and fortiadc license to the deployment folder and change the license file name.
select right zone_id for CEN attachment, you can go to alibaba console to check the proper zone_id. different region has different zone_id

2. modify provider.tf to use your own profile on alibaba cloud account.
3. deployment
terraform apply 

after deployment

in this version, fortiadc cloud init does not work.
so you have to upload license to fortiadc and configure fortiadc.

fortiadc_config.conf  file is just placehold for future , it will not be loaded by cloud-init 
you can either go to fortiadc GUI to upload license for use cli to update license.

the license file has been uploaded to tftp server  192.168.12.60 (you client machine) already. 

FortiADC-ALI # execute vm license tftp FADLICENSE.lic 192.168.12.60


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






