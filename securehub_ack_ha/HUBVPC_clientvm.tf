
data "alicloud_instance_types" "client_vm_types_ds" {
  cpu_core_count = 2
  memory_size    = 4
}

variable "fadLicense" {
  default = "./FADV040000225874.lic"
}

resource "alicloud_instance" "client-vm" {
 //depends_on = [alicloud_instance.PrimaryFortigate,alicloud_cs_managed_kubernetes.k8s_ack1,alicloud_cs_managed_kubernetes.k8s_ack2,time_sleep.wait_900_seconds,alicloud_route_entry.to_ack1,alicloud_route_entry.to_ack2]
  depends_on = [alicloud_cen_transit_router_vpc_attachment.atta_fortiadc]
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  internet_max_bandwidth_out = var.client_vm_internet_max_bandwidth_out=="1" ? 10 : null
  security_groups = alicloud_security_group.SecGroup.*.id
//  instance_type="${data.alicloud_instance_types.client_vm_types_ds.instance_types.0.id}"
  instance_type = var.client_vm_instance_type
 instance_name              = "client-ubuntu-${random_string.random_name_post.result}"
  vswitch_id                 = alicloud_vswitch.internal_a_0.id
  password= var.client_vm_password
  private_ip = var.client_vm_private_ip
  tags = {
    Name = "Terraform-clientvm"
  }
  provisioner "file" {
      source = "~/.kube/config_ack1"
      destination ="/root/kubeconfig_ack1" 
   }
 
  provisioner "file" {
      source = "~/.kube/config_ack2"
      destination ="/root/kubeconfig_ack2"
}

 provisioner "file" {
      source = "~/kubectl"
      destination = "/root/kubectl"
}

  provisioner "file" {
     // source = "./FADV040000225874.lic"
      source = "${var.fadLicense}"
      destination ="/root/FADLICENSE.lic"
    }

 provisioner "file" {
      source ="./k8s_nginx_deployment.yaml"
      destination = "/root/k8s_nginx_deployment.yaml"
}

 provisioner "file" {
      source = "./k8s_svc_nginx.yaml"
      destination = "/root/k8s_svc_nginx.yaml"
}

  provisioner "remote-exec" {
     inline = [
       "echo curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
       "sleep 2",
       "sudo install -o root -g root -m 0755 /root/kubectl /usr/local/bin/kubectl",
       "sleep 2",
       "mkdir -p /root/.kube",
       "mv /root/kubeconfig_ack2 /root/.kube/config_ack2",
       "mv /root/kubeconfig_ack1 /root/.kube/config_ack1",
       "apt update",
       "apt install tftp-server",
       "cp /root/FADLICENSE.lic /var/lib/tftpboot",
       "sleep 120",
       "echo start create service account ftntconnector",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack1",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack2",
       "kubectl -n kube-system create serviceaccount ftntconnector --kubeconfig=/root/.kube/config_ack2",
       "sleep 2",
       "kubectl apply -f k8s_nginx_deployment.yaml --kubeconfig=/root/.kube/config_ack1",
       "kubectl apply -f k8s_svc_nginx.yaml --kubeconfig=/root/.kube/config_ack1",
       "kubectl apply -f k8s_nginx_deployment.yaml --kubeconfig=/root/.kube/config_ack2",
       "kubectl apply -f k8s_svc_nginx.yaml --kubeconfig=/root/.kube/config_ack2",
       "kubectl create clusterrolebinding service-admin --clusterrole=cluster-admin --serviceaccount=kube-system:ftntconnector --kubeconfig=/root/.kube/config_ack2",
       "sleep 2",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack2",
       "sleep 2",
       "kubectl describe secrets ftntconnector -n kube-system --kubeconfig=/root/.kube/config_ack2",
       "sleep 2",
       "kubectl -n kube-system create serviceaccount ftntconnector --kubeconfig=/root/.kube/config_ack1",
       "sleep 2",
       "kubectl create clusterrolebinding service-admin --clusterrole=cluster-admin --serviceaccount=kube-system:ftntconnector --kubeconfig=/root/.kube/config_ack1",
       "sleep 2", 
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack1",
       "sleep 2",
       "kubectl describe secrets ftntconnector -n kube-system --kubeconfig=/root/.kube/config_ack1",
       "sleep 2",
       "kubectl get node -o wide --kubeconfig=/root/.kube/config_ack2",
       "sleep 2",
       "kubectl get node -o wide --kubeconfig=/root/.kube/config_ack1",
       "echo alias kubectl1=\"'kubectl --kubeconfig=/root/.kube/config_ack1'\" >>~/.bashrc",
       "echo alias kubectl2=\"'kubectl --kubeconfig=/root/.kube/config_ack2'\" >>~/.bashrc",
       ".  ~/.bashrc",
       "kubectl1 get pod -o wide",
       "kubectl2 get pod -o wide"

     ]
   }

connection {
//  host = "${alicloud_instance.PrimaryFortigate.public_ip}"
//host = "${element(aws_instance.example.*.public_ip, count.index)}"
  host= local.num_secondary_instances=="1" ? alicloud_eip.PublicInternetIp.ip_address : alicloud_instance.PrimaryFortigate.public_ip
  type = "ssh"
  port = "${var.client_vm_ssh_port}"
  user = "${var.client_vm_username}"
  timeout = "180s"
  password = "${var.client_vm_password}"
}

}


