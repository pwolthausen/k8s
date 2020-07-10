
define app
	$(eval key ?= '~/.ssh/id_pub')
	$(eval TAGS ?= 'all' )
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook -i hosts $(1).yaml --flush-cache --private-key $(key) -t $(TAGS)
endef

k8s:
	$(call app, full_cluster)
