DOCKER_PREFIX ?= huntprod/
DOCKERS :=
DOCKERS += k8s-bosh-kube-proxy
DOCKERS += k8s-bosh-smoke-test

default:
	@echo "please choose a make target..."

dockers: $(DOCKERS)
k8s-bosh-%: images/%/Dockerfile
	docker build -t $(DOCKER_PREFIX)$@:1.12.0 images/$*

update:
	./utils/update-from-upstream

certs:
	# etcd
	./utils/certify-me ca api jobs/etcd/templates/tls/ca
	# control
	./utils/certify-me ca   - jobs/control/templates/tls/ca
	# kubelet
	./utils/certify-me ca api jobs/kubelet/templates/tls/ca
	# jumpbox
	./utils/certify-me ca api jobs/jumpbox/templates/tls/ca
	# smoke-test
	./utils/certify-me ca api jobs/smoke-tests/templates/tls/ca
