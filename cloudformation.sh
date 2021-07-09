#!/usr/bin/env bash

CLUSTER_NAME=${STACK_NAME}

aws cloudformation create-stack \
    --stack-name ${STACK_NAME} \
    --template-body file://cloudformation/ecs.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
        ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME} \
        ParameterKey=Project,ParameterValue=${PROJECT} \
        ParameterKey=Client,ParameterValue=${CLIENT} \
        ParameterKey=Owner,ParameterValue=${OWNER} \
        ParameterKey=DockerImage,ParameterValue=${DOCKER_IMAGE}

echo
echo
echo "Check the stack at: https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks"
