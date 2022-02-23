# This script gets logs for fargate process

set -euo pipefail
CLUSTER_NAME=${STACK_NAME}
LOG_GROUP=${CLUSTER_NAME}-log-group
echo
echo ${LOG_GROUP}
echo

logStreamNames=$(aws logs describe-log-streams --log-group-name ${LOG_GROUP} | jq ".logStreams |= sort_by(.creationTime)" | jq ".logStreams[].logStreamName")

for logStreamNames in $logStreamNames; do
    echo aws logs get-log-events --log-group-name ${LOG_GROUP} --log-stream-name $logStreamNames \| jq ".events[].message"
done
