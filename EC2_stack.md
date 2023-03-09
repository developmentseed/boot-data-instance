## Start up a EC2 stack

Start a EC2 instance with:

- docker
- aws cli
- ssh

```bash
    export KEYNAME="rub21_2022"
    export INSTANCETYPE="t2.nano"
    export STACK_NAME="reforestamos"
    export PROJECT="osm-seed"
    export CLIENT="reforestamos"
    export OWNER="rub21"
    ./ec2_stack.sh $KEYNAME $INSTANCETYPE
```
Instance types at: https://aws.amazon.com/ec2/instance-types/


- Get URL to SSH to the instance

```bash
aws cloudformation describe-stacks --stack-name ${STACK_NAME} | jq .Stacks[0].Outputs[0].OutputValue
```

- SSH in the instances

```bash
ssh -i <path to>/${KEYNAME} 
```

- Get public ssh key to set in Github in order to access to private repos

```bash
sudo cat /root/.ssh/id_rsa.pub
```

- Delete stack

```bash
    aws cloudformation delete-stack --stack-name ${STACK_NAME}
```