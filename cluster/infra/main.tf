provider "cloudca" {
  api_key = var.api_key
  api_url = "https://api.cloud.ca/v1"
}

data "template_file" "cloudinit" {
  template = file("./templates/cloudinit.tpl")
}

resource "cloudca_public_ip" "nat_ip" {
  environment_id = var.envID
  vpc_id         = var.vpcID
}

resource "cloudca_instance" "masters" {
  count                  = var.master_count
  name                   = format("kubeadm-test-master-%02d", count.index + 1)
  environment_id         = var.envID
  network_id             = var.netID
  template               = var.template
  compute_offering       = "Standard"
  cpu_count              = var.master_cpu_count
  memory_in_mb           = var.master_mem_count
  ssh_key_name           = var.ssh_key_name
  root_volume_size_in_gb = var.master_disk_size
  private_ip             = var.master_ip[count.index]
  user_data              = data.template_file.cloudinit.rendered
}
resource "cloudca_port_forwarding_rule" "masters" {
  count              = var.master_count
  environment_id     = var.envID
  public_ip_id       = cloudca_public_ip.nat_ip.id
  public_port_start  = 22 + count.index
  private_ip_id      = cloudca_instance.masters[count.index].private_ip_id
  private_port_start = 22
  protocol           = "TCP"
}
resource "cloudca_public_ip" "master_ep" {
  environment_id = var.envID
  vpc_id         = var.vpcID
}
resource "cloudca_load_balancer_rule" "master_lb" {
  environment_id = var.envID
  name           = "master-endpoint"
  network_id     = var.netID
  public_ip_id   = cloudca_public_ip.master_ep.id
  protocol       = "tcp"
  algorithm      = "roundrobin"
  public_port    = 6443
  private_port   = 6443
  instance_ids   = cloudca_instance.masters.*.id

}

resource "cloudca_instance" "workers" {
  count                  = var.worker_count
  name                   = format("kubeadm-test-worker-%02d", count.index + 1)
  environment_id         = var.envID
  network_id             = var.netID
  template               = var.template
  compute_offering       = "Standard"
  cpu_count              = var.worker_cpu_count
  memory_in_mb           = var.worker_mem_count
  ssh_key_name           = var.ssh_key_name
  root_volume_size_in_gb = var.worker_disk_size
  private_ip             = var.worker_ip[count.index]
  user_data              = data.template_file.cloudinit.rendered
}
resource "cloudca_port_forwarding_rule" "workers" {
  count              = var.worker_count
  environment_id     = var.envID
  public_ip_id       = "aa8068eb-8a89-465f-8fe2-94d34952ee85"
  public_port_start  = 25 + count.index
  private_ip_id      = cloudca_instance.workers[count.index].private_ip_id
  private_port_start = 22
  protocol           = "TCP"
}
