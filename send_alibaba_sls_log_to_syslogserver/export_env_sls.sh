#aliyunlog log  get_log_all  --project=testtest00123asf --logstore=test --query="content" --from_time="2018-01-24 16:00:00+8:00" --to_time="2023-01-24 17:00:00 +8:00" | jq
#aliyunlog log get_check_point --project=testtest00123asf --logstore=test --consumer_group=test --shard=1
project_name="testtest00123asf"
logstore_name=$project_name
consumer_group=$project_name
export SLS_ENDPOINT=cn-hongkong.log.aliyuncs.com
export SLS_AK_ID=$(grep access-id ~/.aliyunlogcli | cut -d ' ' -f 3)
export SLS_AK_KEY=$(grep access-key ~/.aliyunlogcli | cut -d ' ' -f 3)
export SLS_PROJECT=$project_name
export SLS_LOGSTORE=$logsotre_name
export SLS_CG=$consumer_group
export SYSLOG_SERVER='127.0.0.1'
