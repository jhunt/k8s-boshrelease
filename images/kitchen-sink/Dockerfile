FROM ubuntu:latest AS build
RUN mkdir -p /build \
 && apt-get update \
 && apt-get install -y curl \
 && echo "retrieving kube-apiserver..." \
 && curl -sLo /build/kube-apiserver          https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-apiserver \
 && echo "retrieving kube-controller-manager..." \
 && curl -sLo /build/kube-controller-manager https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-controller-manager \
 && echo "retrieving kube-scheduler..." \
 && curl -sLo /build/kube-scheduler          https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-scheduler \
 && echo "retrieving etcd..." \
 && curl -sLo etcd.tar.gz https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz \
 && tar -xf etcd.tar.gz \
 && mv etcd-v3.3.9-linux-amd64/etcd* /build \
 && chmod 755 /build/*

FROM scratch
MAINTAINER James Hunt <james@niftylogic.com>
COPY --from=build /build/ /
