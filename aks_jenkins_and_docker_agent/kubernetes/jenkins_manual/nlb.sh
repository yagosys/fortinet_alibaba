kubectl expose service jenkins-ui --port=8080 --target-port=8080 --name=nlb-jenkins-ui --type=LoadBalancer -n jenkins
