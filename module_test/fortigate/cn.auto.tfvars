instance_type="ecs.hfc6.2xlarge"
number_of_fortigate=2
number_of_zone=2
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
                    "10.0.21.253",
                ]
            port2gateway = [
                     "10.0.12.253",
                     "10.0.22.253",
                ]
            mgmt_gateway_ip =[
                    "10.0.14.253",
                    "10.0.24.253",
                ]
            ha_peer_ip = [
                    "10.0.23.12",
                    "10.0.13.11"
		]
}
