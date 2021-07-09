#!/usr/bin/env bash
export CLUSTER_NAME=super-tiles-v2
STACK_NAME=fargate-process


# aws cloudformation create-stack \
#     --stack-name $STACK_NAME \
#     --template-body file://cloudformation/ecs.yaml \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameters \
#         ParameterKey=ClusterName,ParameterValue=super-tiles-v2 \
#         ParameterKey=Project,ParameterValue=ffda \
#         ParameterKey=DockerImage,ParameterValue=552819999234.dkr.ecr.us-east-1.amazonaws.com/ffda-poi/supertiles:v1



# aws cloudformation update-stack \
#     --stack-name $STACK_NAME \
#     --template-body file://cloudformation/ecs.yaml \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameters \
#         ParameterKey=ClusterName,ParameterValue=super-tiles-v2 \
#         ParameterKey=Project,ParameterValue=ffda \
#         ParameterKey=DockerImage,ParameterValue=552819999234.dkr.ecr.us-east-1.amazonaws.com/ffda-poi/supertiles:v1


aws cloudformation delete-stack --stack-name $STACK_NAME