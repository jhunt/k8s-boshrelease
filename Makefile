DOCKER_PREFIX ?= huntprod/


default:
	@echo "please choose a make target..."

dockers: k8s-bosh-kitchen-sink k8s-bosh-kube-proxy
k8s-bosh-%: images/%/Dockerfile
	docker build -t $(DOCKER_PREFIX)$@:1.12.0 images/$*

update:
	./utils/update-from-upstream

certs:
	# control
	./utils/certify-me ca   - jobs/control/templates/tls/ca
	# kubelet
	./utils/certify-me ca api jobs/kubelet/templates/tls/ca
	# jumpbox
	./utils/certify-me ca api jobs/jumpbox/templates/tls/ca
