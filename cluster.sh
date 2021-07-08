#!/usr/bin/env bash
mkdir -p tmp

echo "CLUSTER_NAME: ${CLUSTER_NAME}"
echo "ECR_REPOSITORY: ${ECR_REPOSITORY}"
echo "TASK_DEFINITION: ${TASK_DEFINITION}"
echo "ACCOUNT_ID: ${ACCOUNT_ID}"
echo
echo
echo

LOG_GROUP=/ecs/$TASK_DEFINITION

echo "Creating cluster..."
aws ecs create-cluster --cluster-name $CLUSTER_NAME

echo "Creating log group..."
aws logs create-log-group --log-group-name $LOG_GROUP

echo "Creating task definition..."
python3 task-definition.py --ecr_repository=$ECR_REPOSITORY --task_definition=$TASK_DEFINITION --account_id=$ACCOUNT_ID >tmp/task_def.json
aws ecs register-task-definition --cli-input-json file://tmp/task_def.json
# aws ecs list-task-definitions
