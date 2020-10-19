get-modules:
	terraform init
	terraform get

plan: get-modules
	terraform plan -var-file variables.tfvars -out kubeadm.tfplan

apply: get-modules
	terraform apply kubeadm.tfplan

destroy: get-modules
	terraform plan -destroy -var-file variables.tfvars -out kubeadm.tfplan

refresh:
	terraform refresh -var-file variables.tfvars
