# Enabling AWS Cloud Provider Support in Kubernetes

This document discusses what must be done to enable native
integration with this Kubernetes BOSH release and AWS as an IaaS.
This allows your new cluster to:

  1. Provision persistent volumes (via EBS) on-demand
  2. Set up LoadBalancers as {E,A,N}LBs, for Services

## Overview of How It Works

The cloud provider for AWS needs no on-box configuration.  It can,
however, only be activated on a bona fide EC2 instance.  This is
rarely a problem.

Kubelet EC2 instances are subject to the following requirements:

  1. They must have an IAM Instance Profile.
  2. They must be named appropriately.

The IAM profile allows the code to access an access key ID and
secret access key pair by way of a curl to the instance-local
metadata service (running on a well-known APIPA 169.x.x.x)
address.  These credentials are then used for all interactions
with the various AWS APIs (chiefly EC2 / EBS / ELB).


### Persistent Volumes

When a persistent volume claim is made against a storage class
backed by the AWS provisioner, the cloud provider does the
following:

  1. Provision an EBS volume, using the Amazon-specific
     configuration in the storage class, and the capacity
     requested in the claim.

  2. Attaches the EBS volume to the kubelet chosen by the
     scheduler to run the claimant pods.

### LoadBalancer Services

When a Service of `type: LoadBalancer` is seen by the cloud
provider, it does the following:

  1. Set up a NodePort (this is _technically_ a kube-proxy /
     low-level Kubernetes thing), and note the chosen port number.

  2. Create a security group for governing the access from the
     eventual ELB to the target group instances, on the NodePort.

  3. Attach the security group to the subnet that (presumably) is
     attached to the node EC2 instances.  This is done by tagging
     (see below).

  4. Create an ELB, residing in a **public** subnet that is
     appropriately tagged (also see below).

  5. Wire up the instances in the EndPoint for the Service to the
     ELB in Amazon.  This is done by mapping the node name to its
     canonical hostname (`ip-$address.$region.compute.internal`).

### Tagging Resources in AWS

Tags are critical to the operation of the AWS Cloud Provider.
Without tags, the provider will be unable to enumerate the bits
and pieces of the cloud infrastructure that it needs to integrate
with.

Each cluster has its own tag, which can have one of two values:
`owned` or `shared`.  In most cases, operators will want to
manually tag resources as `shared`, to keep the cloud provider
form mistakenly deleting them.

The format of a cluster tag is:

    kubernetes.io/cluster/$CLUSTER=(owned|shared)

... where `$CLUSTER` is the internal custer name (the
`cluster.name` BOSH manifest property).

The following things need to be tagged:

  - The kubernetes node EC2 instances
  - The subnet that the nodes live in
  - The public subnet to put load balancers in

## IAM Instance Profiles

First, define an _IAM Policy_ that gives enough credentials inside
of AWS to perform the provider actions (provisioning EBS volumes,
creating load balancers, updating EC2 configuration, etc.).

Here's a starting point that works, but could use with some more
rigor and more narrowed focus:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "ec2:*",
            "elasticloadbalancing:*"
          ],
          "Resource": [
            "*"
          ]
        }
      ]
    }

This IAM policy is generic enough that you can use it for any
number of BOSH-deployed Kubernetes clusters.  You can name it
accordingly, i.e. `kubernetes-cloud-provider`.

Next, create an IAM Role associated with that policy.  The role
has to be an _EC2 Role_, since it gets attached to EC2 instances.
The role itself does not need any specific AWS tags, but feel free
to tag it however you need for billing and compliance purposes.

For convenience' sake / ease-of-use, name the role after the
policy, i.e. `kubernetes-cloud-provider`.

## BOSH Cloud Configuration

The IAM Instance Profile (really, an IAM Role + Policy) must be
attached to the Kubernetes node EC2 instances, which BOSH can do
via a custom cloud property that the BOSH AWS CPI will pick up and
make use of.

The example manifests in this release repository already associate
the kubelet instance groups with a BOSH VM Extension named
`kubelet`, so your cloud configuration can use that, like this:

    vm_extensions:
      - name: kubelet
        cloud-properties:
          iam_instance_profile: kubernetes-cloud-provider

## AWS Tagging

To tag the EC2 nodes so that the AWS cloud provider can find them,
use BOSH's top-level `tags` key:

    tags:
      kubernetes.io/cluster/CLUSTER: shared

Note that because the tag _itself_ has the cluster name in it, it
is difficult to merge with tools like spruce, so this often needs
to be manually specified in every deployment.

Also note: in the "hugernetes" topology, the etcd role is handled
by a completely separate instance group.  These instances will
also be tagged with the cluster tag, but that _should_ not cause
any issues.
