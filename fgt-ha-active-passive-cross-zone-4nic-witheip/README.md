create your own alibaba cloud profile with your own access key id and credentail according https://www.alibabacloud.com/help/en/doc-detail/90766.htm

Usage
edit cn.auto.tfvars with your own parameters

//instance_ami="m-j6cj2liju58d88zmgbdg"  //or auto for use latest image based on product name
account_region="intl" //or china for china alibaba account

license_type="pygo" //or byol , if using byol. a license file for two fortigate must be placed in the same directory. 

region="cn-hongkong"

//license1="./FGVMULTM22000730.lic" 

//license2="./FGVMULTM22000750.lic"

license1="./nolicense.lic" //this is for when using PYGO. the license file is empty. 

license2="./nolicense.lic"

then do

terraform init

terraform apply

