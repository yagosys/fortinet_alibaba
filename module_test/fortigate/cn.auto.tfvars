instance_type="auto"
image_id="m-j6cj2liju58d88zmgbdg"
number_of_fortigate=2
number_of_zone=1
custom_rt=1
mgmt_eip=1
eip=1
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
            defaultgwy = [
                    "10.0.11.253",
                    "10.0.11.253",
                ]
            port2gateway = [
                     "10.0.12.253",
                     "10.0.12.253",
                ]
            mgmt_gateway_ip =[
                    "10.0.14.253",
                    "10.0.14.253",
                ]
            ha_peer_ip = [
                    "10.0.13.12",
                    "10.0.13.11"
		]
}

        cidr_block = {
                external = [
                        "10.0.11.0/24",
                        "10.0.11.0/24",
                ]
                internal = [
                        "10.0.12.0/24",
                        "10.0.12.0/24",
                ]
                ha = [
                        "10.0.13.0/24",
                        "10.0.13.0/24",
                ]
                mgmt = [
                        "10.0.14.0/24",
                        "10.0.14.0/24",
                ]
                internal_cidr = [
                        "10.0.0.0/16"
                ]
        }

       cidr_block_ip = {
             external = [
                   "10.0.11.11",
                   "10.0.11.12",
                ]
              internal = [
                   "10.0.12.11",
                   "10.0.12.12",
                ]
              ha = [
                   "10.0.13.11",
                   "10.0.13.12",
                ]
              mgmt = [
                    "10.0.14.11",
                    "10.0.14.12",
                ]
        }
