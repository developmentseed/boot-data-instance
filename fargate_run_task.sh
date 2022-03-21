# This script does not check arguments.  To see the valid arguments, see
# write_tfrecords.py.  If you supply invalid arguments to this script, the ECS task
# is still kicked off, but you will need to look at the logs to see any message
# describing argument errors.

set -euo pipefail

CLUSTER_NAME=${STACK_NAME}
TASK_DEFINITION=${CLUSTER_NAME}-task-definition
LOG_GROUP=${CLUSTER_NAME}-log-group
CONTAINER_DEFINITIONS=${CLUSTER_NAME}-container

echo "CLUSTER_NAME: ${CLUSTER_NAME}"
echo "TASK_DEFINITION: ${TASK_DEFINITION}"
echo "LOG_GROUP: ${LOG_GROUP}"
echo "CONTAINER_DEFINITIONS: ${CONTAINER_DEFINITIONS}"
echo

_args=""

# ECS task container override command.
for _arg in $@; do
  _args=${_args:+${_args},}\"${_arg}\"
done

_command="${_args}"

_subnet_id=$(
  aws ec2 describe-subnets \
    --output text \
    --query "Subnets[0].SubnetId"
)

######################### 
# For running comand line
#########################

# aws ecs run-task \
#   --cluster ${CLUSTER_NAME} \
#   --count 1 \
#   --launch-type FARGATE \
#   --network-configuration "awsvpcConfiguration={subnets=[${_subnet_id}],assignPublicIp=ENABLED}" \
#   --overrides "containerOverrides=[{name=${CONTAINER_DEFINITIONS},command=[${_command}]}]" \
#   --task-definition ${TASK_DEFINITION}


######################### 
# For running mor complex comand lines
# Make a copy of example_override.json and edit the file
#########################
overrideFile=overrides/cpal.json

sed -i -e 's/"name": "..."/"name": "'$CONTAINER_DEFINITIONS'"/g' $overrideFile

aws ecs run-task \
  --cluster ${CLUSTER_NAME} \
  --count 1 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[${_subnet_id}],assignPublicIp=ENABLED}" \
  --overrides file://$overrideFile \
  --task-definition ${TASK_DEFINITION} | jq .

echo
echo "aws logs filter-log-events --log-group-name ${LOG_GROUP} --query events[].message --start-time $(($(date +%s) * 1000 - 300000)) --output text | tr \t \n | tail -n 50"
echo
echo
