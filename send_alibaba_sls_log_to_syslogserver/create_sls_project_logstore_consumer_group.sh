#aliyunlog log  get_log_all  --project=testtest00123asf --logstore=test --query="content" --from_time="2018-01-24 16:00:00+8:00" --to_time="2023-01-24 17:00:00 +8:00" | jq
#aliyunlog log get_check_point --project=testtest00123asf --logstore=test --consumer_group=test --shard=1
#aliyunlog log get_machine_group --project_name="testtest00123asf" --group_name="iecs-148531"
project_name="testtestasdfadsf"
logstore_name=$project_name
consumer_group=$project_name
aliyunlog log create_project --project_name=$project_name --project_des="project created from cli"
aliyunlog log create_logstore --project_name=$project_name --logstore_name=$logstore_name
aliyunlog log create_consumer_group --project=$project_name --logstore=$logstore_name --consumer_group=$consumer_group --timeout=300
aliyunlog log create_machine_group --project_name=$project_name --group_detail="file://./machinegroup.json"
