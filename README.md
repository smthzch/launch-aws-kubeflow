# Kubeflow on AWS

Kubleflow is a mlops tool designed to handle all stages of a machine learning project from exploration -> training -> deployment

This repo follows the setup from AWS' Kubeflow dsitribution in order to launch a Kubeflow cluster.

Included is a Dockerfile to handle some of the requirements.

Otherwise an AWS account and key/secret are needed to deploy.

# Setup

https://awslabs.github.io/kubeflow-manifests/docs/deployment/prerequisites/

First build a docker image with the necessary tools using the Dockerfile.

```shell
docker build \
    --build-arg AWS_ACCESS_KEY_ID=<Your KEY> \
    --build-arg AWS_SECRET_ACCESS_KEY=<Your Secret> \
    -t kubeflow .
docker run -d --name kubeflow -p 127.0.0.1:8080:8080 kubeflow
docker start kubeflow
```

# Vanilla Kubeflow

https://awslabs.github.io/kubeflow-manifests/docs/deployment/vanilla/guide-terraform/

These steps launch a vanilla Kubernetes cluster on AWS and port forward the Kubeflow dashboard port.

```shell
docker exec -it kubeflow bash
cd deployments/vanilla/terraform

# Region to create the cluster in
export CLUSTER_REGION=us-east-1
# Name of the cluster to create
export CLUSTER_NAME=test-kubeflow

cat <<EOF > sample.auto.tfvars
cluster_name="${CLUSTER_NAME}"
cluster_region="${CLUSTER_REGION}"
EOF

terraform init && terraform plan

make deploy

# enable port forwarding of kubeflow control
$(terraform output -raw configure_kubectl)
cd /kubeflow/kubeflow-manifests
make port-forward IP_ADDRESS=0.0.0.0
```

To shutdown the cluster.

```shell
cd deployments/vanilla/terraform
make delete
```

# Example

https://github.com/kubeflow/examples/tree/master/mnist#aws


