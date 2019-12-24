
define app
	$(eval key ?= '~/.ssh/id_pub')
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook -i hosts $(1).yaml --flush-cache --private-key $(key)
endef

cluster_dep:
	$(call app,cluster_dep)

masters:
	$(call app,masters)

workers:
	$(call app,workers)
