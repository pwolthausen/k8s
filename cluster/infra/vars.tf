variable "api_key" {}
variable "envID" {}
variable "vpcID" {}
variable "netID" {}
variable "template" {}
variable "ssh_key_name" {}

variable "master_count" {}
variable "master_cpu_count" {
  default = 2
}
variable "master_mem_count" {
  default = 4096
}
variable "master_disk_size" {
  default = 50
}
variable "master_ip" {
  type    = list
  default = ["10.220.124.10", "10.220.124.11", "10.220.124.12"]
}

variable "worker_count" {
  default = 3
}
variable "worker_cpu_count" {
  default = 2
}
variable "worker_mem_count" {
  default = 4096
}
variable "worker_disk_size" {
  default = 100
}
variable "worker_ip" {
  type    = list
  default = ["10.220.124.13", "10.220.124.14", "10.220.124.15", "10.220.124.16", "10.220.124.17", "10.220.124.18", "10.220.124.19"]
}
