
define app
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook -i inventory.ini $(1).yaml --flush-cache
endef

k8s:
	$(call app, create_cluster)
