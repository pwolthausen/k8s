1. Create SSH key pair. Copy the public key to each of the nodes to be used in the cluster. The basic method is to [create the key pair manually](https://www.ssh.com/ssh/keygen), however, if you are using a cloud provider, the provider may offer built in methods to create, share, and use ssh keys.  

2. Populate your `hosts` inventory file. Just fill in the external IP addresses of each node for a basic inventory or view the [ansible documentation on how to build an inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#inventory-basics-formats-hosts-and-groups).

3. (Optional) At this point, you can run the first part of the playbook to install the [k8s pre-requisites](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime) on your hosts. You can do so with the following command:

>>>> make cluster_prep

NOTE if your privte SSH key is not `~/.ssh/id_pub` make sure to add `key=[path to your ssh key]` to the make command

The 2 playbooks being run (`masters.yaml` and `workers.yaml`) will install docker, kubeadm, kubectl, and the kubelet on the necessary nodes. If you want to run each of these playbooks separately, you can.

4.

- I am using calico as the network mesh, using a different network mesh is fine. Just make sure to review the documentation to make sure that all the required steps are being followed. If you want to use a different network for your cluster, update the field in group_vars for `network`
