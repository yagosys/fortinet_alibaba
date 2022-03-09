ipaddress="47.243.245.92"
[[ $(ping $ipaddress -w 1200 -c10) ]] && echo fortigate is reachable now || exit 1
token=`ssh -i mykey -oStrictHostKeyChecking=no admin@47.243.245.92 execute api-user generate-key soc2`
tokenstring=`echo $token | cut -d " " -f6`
echo $tokenstring
adminsport="8443"
export FORTIOS_ACCESS_HOSTNAME=$ipaddress:$adminsport
export FORTIOS_ACCESS_TOKEN=$tokenstring
export FORTIOS_INSECURE=true
echo ipsec_peer_source=$ipaddress
