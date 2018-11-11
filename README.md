k8s BOSH Release
================

This is a BOSH release for spinning Kubernetes 1.12.0, using BOSH
to orchestrate the "physical" nodes that comprise the various
roles of a Kubernetes cluster (master and worker).

Rationale
---------

This is, at present, an investigative project, wherein I am
attempting to learn how to assemble a working, highly-available
Kubernetes cluster from first principles.

I am following Kelsey Hightower's [Kubernetes the Hard Way][kthw]
write-up.

I am aware of other efforts to BOSH-ify Kubernetes, like
[kubo][kubo].  This project does not aim to replace those other
projects in any way, and if you find joy in using those projects,
please continue using them.

Contributing
------------

I am not currently accepting unrequested PR's or other
contributions to this repository.  As I said, this is a personal
project, for exploring the world of Kubernetes through the lens of
a BOSH director.

If you find this, and manage to get it to work for you, great!
I'd love to hear from you, of your successes and struggles.

[kthw]: https://github.com/kelseyhightower/kubernetes-the-hard-way
[kubo]: https://github.com/cloudfoundry-incubator/kubo-release
