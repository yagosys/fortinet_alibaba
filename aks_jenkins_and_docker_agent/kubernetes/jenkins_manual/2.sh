echo $(kubectl get svc nlb-jenkins-ui -n jenkins -o jsonpath="{.status.loadBalancer.ingress[*]}")


