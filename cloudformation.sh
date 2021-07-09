#!/usr/bin/env bash

CLUSTER_NAME=${STACK_NAME}-cluster

aws cloudformation create-stack \
    --stack-name ${STACK_NAME} \
    --template-body file://cloudformation/ecs.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
        ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME} \
        ParameterKey=Project,ParameterValue=${PROJECT} \
        ParameterKey=DockerImage,ParameterValue=${DOCKER_IMAGE}
