default:
	@echo "please choose a make target..."

update:
	./utils/update-from-upstream

certs:
	# etcd
	./utils/certify-me ca  jobs/etcd/templates/tls/ca
	./utils/certify-me api jobs/etcd/templates/tls/etcd
	# api
	./utils/certify-me ca  jobs/api/templates/tls/ca
	./utils/certify-me api jobs/api/templates/tls/api
	# controller manager
	./utils/certify-me ca                 jobs/controller-manager/templates/tls/ca
	./utils/certify-me service-accounts   jobs/controller-manager/templates/tls/sa
	./utils/certify-me controller-manager jobs/controller-manager/templates/tls/controller-manager
	# scheduler
	./utils/certify-me ca        jobs/scheduler/templates/tls/ca
	./utils/certify-me scheduler jobs/scheduler/templates/tls/scheduler
	# proxy
	./utils/certify-me ca    jobs/proxy/templates/tls/ca
	./utils/certify-me proxy jobs/proxy/templates/tls/proxy
	# kubelet
	./utils/certify-me ca      jobs/kubelet/templates/tls/ca
	./utils/certify-me kubelet jobs/kubelet/templates/tls/kubelet
