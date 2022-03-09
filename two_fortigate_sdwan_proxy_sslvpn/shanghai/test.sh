for region in us-east-1 us-west-1  eu-west-1 me-east-1 eu-central-1
do
   terraform apply --auto-approve --var region=$region
   terraform destroy --auto-approve --var region=$region
done
