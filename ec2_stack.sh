#!/usr/bin/env bash
KEYNAME=$1
INSTANCETYPE=$2
aws cloudformation create-stack \
    --stack-name ${STACK_NAME} \
    --template-body file://cloudformation/ec2.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
        ParameterKey=Name,ParameterValue=${STACK_NAME} \
        ParameterKey=Project,ParameterValue=${PROJECT} \
        ParameterKey=Client,ParameterValue=${CLIENT} \
        ParameterKey=Owner,ParameterValue=${OWNER} \
        ParameterKey=KeyName,ParameterValue=${KEYNAME} \
        ParameterKey=InstanceType,ParameterValue=${INSTANCETYPE}
echo
echo
echo "Check the stack at: https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks"
