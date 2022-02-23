## Creating a EC2 stack

In case you wan to spin up a EC2 instance with docker , aws cli installed.

```bash
    export KEYNAME="rub21_2022"
    export INSTANCETYPE="m5.large"
    export STACK_NAME="hot-osm-seed"
    export PROJECT="osm-seed"
    export CLIENT="HOT"
    export OWNER="rub21"
    ./ec2_stack.sh $KEYNAME $INSTANCETYPE
```
Instance types at: https://aws.amazon.com/ec2/instance-types/


Get ssh CLI  to access into the instance

```sh
aws cloudformation describe-stacks --stack-name bri-infra-data-proces | jq .Stacks[0].Outputs[0].OutputValue

sudo cat /root/.ssh/id_rsa.pub
```


Delete stack


```bash
    aws cloudformation delete-stack --stack-name ${STACK_NAME}
```