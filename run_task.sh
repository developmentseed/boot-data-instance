# This script does not check arguments.  To see the valid arguments, see
# write_tfrecords.py.  If you supply invalid arguments to this script, the ECS task
# is still kicked off, but you will need to look at the logs to see any message
# describing argument errors.

set -euo pipefail

echo "CLUSTER_NAME: ${CLUSTER_NAME}"
echo "ECR_REPOSITORY: ${ECR_REPOSITORY}"
echo "TASK_DEFINITION: ${TASK_DEFINITION}"
echo "ACCOUNT_ID: ${ACCOUNT_ID}"
echo
echo
echo

_args=""

# Convert script arguments into a comma-separated list of arguments to pass to the
# ECS task container override command.
for _arg in $@; do
  _args=${_args:+${_args},}\"${_arg}\"
done

_command="${_args}"

_subnet_id=$(
  aws ec2 describe-subnets \
    --filters Name=tag:Name,Values=write-tfrecords/Public \
    --output text \
    --query "Subnets[0].SubnetId"
)

aws ecs run-task \
  --cluster ${CLUSTER_NAME} \
  --count 1 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[${_subnet_id}],assignPublicIp=ENABLED}" \
  --overrides "containerOverrides=[{name=${TASK_DEFINITION},command=[${_command}]}]" \
  --task-definition ${TASK_DEFINITION}

echo
echo "To see the most recent 50 log messages from the past 5 minutes,"
echo "run the following command:"
echo
echo "    aws logs filter-log-events \
        --log-group-name /ecs/${TASK_DEFINITION} \
        --query events[].message \
        --start-time $(($(date +%s) * 1000 - 300000)) \
        --output text | tr \t \n | tail -n 50"
echo
