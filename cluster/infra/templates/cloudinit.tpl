#cloud-config
yum_repos:
  kubernetes:
    baseurl: https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
    name: Kubernetes
    enabled: true
    gpgcheck: true
    gpgkey: https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
  docker-ce-stable:
    baseurl: https://download.docker.com/linux/centos/$releasever/$basearch/stable
    name: Docker CE Stable - $basearch
    gpgcheck: true
    gpgkey: https://download.docker.com/linux/centos/gpg
    enabled: true
package_update: true
packages:
  - ca-certificates
  - curl
  - kubeadm
  - kubelet
  - kubectl
  - docker-ce
  - docker-ce-cli
  - containerd.io
<!-- users:
  - name: cca-user
    groups: docker -->
