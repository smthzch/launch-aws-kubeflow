FROM ubuntu:18.04

EXPOSE 8080

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION=us-east-1
ARG AWS_DEFAULT_OUTPUT=json

ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
ENV AWS_DEFAULT_OUTPUT=${AWS_DEFAULT_OUTPUT}

WORKDIR /kubeflow

RUN apt-get update
RUN apt-get install git curl unzip tar make sudo vim wget -y

ENV KUBEFLOW_RELEASE_VERSION=v1.6.1
ENV AWS_RELEASE_VERSION=v1.6.1-aws-b1.0.0
RUN git clone https://github.com/awslabs/kubeflow-manifests.git
WORKDIR kubeflow-manifests
RUN git checkout ${AWS_RELEASE_VERSION}
RUN git clone --branch ${KUBEFLOW_RELEASE_VERSION} https://github.com/kubeflow/manifests.git upstream

RUN make install-tools

RUN echo 'alias python=python3.8' >> ~/.bashrc

CMD ["tail", "-f", "/dev/null"]
