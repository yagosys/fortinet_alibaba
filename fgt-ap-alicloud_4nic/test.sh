for region in cn-beijing cn-shanghai ap-southeast-1 
do
   terraform apply --auto-approve --var region=$region
   sleep 600
   terraform destroy --auto-approve --var region=$region
done
