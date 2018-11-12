default:
	@echo "please choose a make target..."

update:
	./utils/update-from-upstream

certs:
	# etcd
	./utils/certify-me ca  api jobs/etcd/templates/tls/ca
	# status-of-etcd
	./utils/certify-me ca  api jobs/status-of-etcd/templates/tls/ca
	# control
	./utils/certify-me ca    - jobs/control/templates/tls/ca
	
	# proxy
	./utils/certify-me ca    api jobs/proxy/templates/tls/ca
	./utils/certify-me proxy api jobs/proxy/templates/tls/proxy
	# kubelet
	./utils/certify-me ca      api jobs/kubelet/templates/tls/ca
	./utils/certify-me kubelet api jobs/kubelet/templates/tls/kubelet
	# jumpbox
	./utils/certify-me ca    api jobs/jumpbox/templates/tls/ca
	./utils/certify-me admin api jobs/jumpbox/templates/tls/admin
