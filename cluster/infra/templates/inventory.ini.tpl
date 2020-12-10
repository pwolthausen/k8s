[masters]
%{ for index, master in master_names ~}
${master} ansible_host=${ssh_ip} ansible_port=${master_ssh_port[index]}
%{ endfor ~}

[workers]
%{ for index, worker in worker_names ~}
${worker} ansible_host=${ssh_ip} ansible_port=${worker_ssh_port[index]}
%{ endfor ~}

[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_become=true
ansible_user=cca-user
