variable "client_vm_private_ip" {
   type = string
   default = "10.1.1.172"
}
variable "client_vm_username" {
   default = "root"
}
variable "client_vm_password" {
   default = "Welcome.123"
}
variable "client_vm_ssh_port" {
   default = "22"
}
variable "client_vm_instance_type" {
   default = ""
}

data "alicloud_instance_types" "client_vm_types_ds" {
  cpu_core_count = 2
  memory_size    = 4
}


resource "alicloud_instance" "client-vm" {
  depends_on=[alicloud_cs_managed_kubernetes.k8s]
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  internet_max_bandwidth_out = 10
  security_groups = alicloud_security_group.SecGroup.*.id
  instance_type = var.client_vm_instance_type 
  instance_name              = "ubuntu_k8s_client_jenkins_node"
   vswitch_id                 = alicloud_vswitch.default.id
  password= var.client_vm_password
  private_ip = var.client_vm_private_ip
  tags = {
    Name = "Terraform-clientvm"
  }
  provisioner "file" {
      source = "~/.kube/config"
      destination ="/root/kubeconfig" 
   }
 

 provisioner "file" {
      source ="./jenkins_manual/serviceaccount.yaml"
      destination = "/root/serviceaccount.yaml"
}

 provisioner "file" {
      source = "./jenkins_manual/jenkins_deployment.yaml"
      destination = "/root/jenkins_deployment.yaml"
}

 provisioner "file" {
      source = "./jenkins_manual/jenkinssvc.yaml"
      destination = "/root/jenkinssvc.yaml"

}

 provisioner "file" {
      source = "./jenkins_manual/nlb.yaml"
      destination = "/root/nlb.yaml"
}

provisioner "file" {
      source = "./jenkins_manual/1.sh"
      destination = "/root/1.sh"
}

provisioner "file" {
      source = "./jenkins_manual/2.sh"
      destination = "/root/2.sh"
}

provisioner "file" {
      source = "./docker/daemon.json"
      destination = "/root/daemon.json"
}

provisioner "file" {
      source = "./docker/override.conf"
      destination = "/root/override.conf"
}


provisioner "remote-exec" {
     inline = [
       "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
       "sleep 2",
       "sudo install -o root -g root -m 0755 /root/kubectl /usr/local/bin/kubectl",
       "sleep 2",
       "mkdir -p /root/.kube",
       "mv /root/kubeconfig /root/.kube/config",
       "apt update -y",
       "kubectl get pod -o wide",
       "kubectl create namespace jenkins",
       "kubectl apply -f serviceaccount.yaml",
       "kubectl apply -f jenkins_deployment.yaml",
       "kubectl apply -f jenkinssvc.yaml",
       "kubectl apply -f nlb.yaml",
       "apt install docker.io -y",
       "apt install openjdk-8-jre-headless -y",
       "apt install net-tools -y",
       "cp /root/daemon.json /etc/docker/daemon.json",
       "mkdir -p /etc/systemd/system/docker.service.d/",
       "cp /root/override.conf /etc/systemd/system/docker.service.d/",
       "systemctl daemon-reload",
       "systemctl restart docker.service",
 "kubectl exec po/$(kubectl get pod -n jenkins -o jsonpath='{.items[0].metadata.name}') -n jenkins -- apt update",
       "kubectl exec po/$(kubectl get pod -n jenkins -o jsonpath='{.items[0].metadata.name}') -n jenkins -- apt install docker.io -y"    

     ]
   }

connection {
  host = "${alicloud_instance.client-vm.public_ip}"
  type = "ssh"
  port = "${var.client_vm_ssh_port}"
  user = "${var.client_vm_username}"
  timeout = "180s"
  password = "${var.client_vm_password}"
}

}

output "ubuntu" {
  value = alicloud_instance.client-vm.public_ip
}
output "jenkins_password" {
  value = data.external.jenkins_password.result
}
output "jenkins_url_and_tcp_port_8080" {
  value = data.external.jenkins_url.result
}

data "external" "jenkins_password" {
depends_on=[alicloud_instance.client-vm]
  program = ["bash", "${path.root}/jenkins_manual/1.sh"]
}

data "external" "jenkins_url" {
depends_on=[data.external.jenkins_password,alicloud_instance.client-vm]
  program = ["bash", "${path.root}/jenkins_manual/2.sh"]
}

