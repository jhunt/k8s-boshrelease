FROM ubuntu:latest AS build
RUN mkdir -p /build \
 && apt-get update \
 && apt-get install -y curl \
 && echo "retrieving kube-proxy..." \
 && curl -Lo /build/kube-proxy https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-proxy \
 && chmod 755 /build/*

FROM scratch
MAINTAINER James Hunt <james@niftylogic.com>
COPY --from=build /build/ /
