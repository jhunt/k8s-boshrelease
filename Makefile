default:
	@echo "please choose a make target..."

update:
	./utils/update-from-upstream

certs:
	# etcd
	./utils/certify-me ca  api jobs/etcd/templates/tls/ca
	./utils/certify-me api api jobs/etcd/templates/tls/etcd
	# api
	./utils/certify-me ca               - jobs/api/templates/tls/ca
	./utils/certify-me service-accounts - jobs/api/templates/tls/sa
	./utils/certify-me api              - jobs/api/templates/tls/api
	./utils/certify-me kubelet          - jobs/api/templates/tls/kubelet
	# controller manager
	./utils/certify-me ca                 api jobs/controller-manager/templates/tls/ca
	./utils/certify-me service-accounts   api jobs/controller-manager/templates/tls/sa
	./utils/certify-me controller-manager api jobs/controller-manager/templates/tls/controller-manager
	# scheduler
	./utils/certify-me ca        api jobs/scheduler/templates/tls/ca
	./utils/certify-me scheduler api jobs/scheduler/templates/tls/scheduler
	# proxy
	./utils/certify-me ca    api jobs/proxy/templates/tls/ca
	./utils/certify-me proxy api jobs/proxy/templates/tls/proxy
	# kubelet
	./utils/certify-me ca      api jobs/kubelet/templates/tls/ca
	./utils/certify-me kubelet api jobs/kubelet/templates/tls/kubelet
