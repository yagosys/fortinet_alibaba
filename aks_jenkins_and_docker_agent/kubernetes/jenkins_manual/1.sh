podname=$(kubectl get pod -n jenkins -o jsonpath="{.items[0].metadata.name}")
test=$(kubectl exec po/$podname -n jenkins -- tail  /var/jenkins_home/secrets/initialAdminPassword)
echo  "{\""password\"": \"${test}\"}"  | jq .


