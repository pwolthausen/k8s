
define app
	$(eval key ?= '~/.ssh/id_pub')
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook -i hosts $(1).yaml --flush-cache --private-key $(key)
endef

node_prep:
	$(call app,node_prep)

masters:
	$(call app,masters)

workers:
	$(call app,workers)

create:
	$(call app,create_cluster)

join:
	$(call app, join)

full:
	$(call app, full_cluster)
