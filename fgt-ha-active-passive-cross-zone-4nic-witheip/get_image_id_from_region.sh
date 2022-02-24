region="$1"
product="$2"
imageowner="$3"

[[ "$1" == "" ]] && region="cn-zhangjiakou"
[[ "$2" == "" ]] && product="FortiGate-6.4.5.+BYOL"
[[ "$3" == "" ]] && imageowner="marketplace"

echo get image id from $region for $product
for i in {1..20};do aliyun ecs DescribeImages --ImageOwnerAlias=$imageowner --region=$region --RegionId=$region --PageNumber=$i --PageSize=100  | jq '.Images.Image[] | .ImageName +" " +.ImageId + " "+.ProductCode' | grep -E  --ignore-case $product ;done
