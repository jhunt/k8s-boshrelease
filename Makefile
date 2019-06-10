DOCKER_PREFIX ?= huntprod/
DOCKERS :=
DOCKERS += k8s-bosh-kube-proxy
DOCKERS += k8s-bosh-smoke-test

default:
	@echo "please choose a make target..."

dockers: $(DOCKERS)
k8s-bosh-%: images/%/Dockerfile
	docker build -t $(DOCKER_PREFIX)$@:1.14.0 images/$*

update:
	./utils/update-from-upstream

release:
	@echo "Checking that VERSION was defined in the calling environment"
	@test -n "$(VERSION)"
	@echo "OK.  VERSION=$(VERSION)"
	git stash
	bosh create-release --final --tarball=releases/k8s-$(VERSION).tgz --name k8s --version $(VERSION)
	git add releases/k8s .final_builds
	git commit -m "Release v$(VERSION)"
	git tag v$(VERSION)
	git stash pop

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
