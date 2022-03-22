instance_type="auto"
subnet_cidr="10.0.0.0/16"
image_id="m-j6cj2liju58d88zmgbdg"
most_recent_image_search_string_from_marketplace="FortiGate-6.4.5.+BYOL"
number_of_fortigate=2
number_of_zone=2
custom_rt=1
mgmt_eip=1
eip=1

cpu_core_count=8
memory_size=16
eni_amount=4

fortigate= {
          hostname=[
                    "fortigate-active",
                    "fortigate-passive",
                ]
            license_file=[
                    "./FGVMULTM22000730.lic",
                    "./FGVMULTM22000750.lic",
                ]
            internet_max_bandwidth_out=[
                    "0",
                    "0",
                ]
            ha_priority=[
                     "200",
                     "100",
                ]
}
