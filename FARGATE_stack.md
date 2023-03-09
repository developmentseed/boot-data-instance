# Start up an EC2 fargate instance

This repo aims to start up a EC2 with all required stuff for data processing  or execute any docker container in Fargate. 

**Why was this repo created?**

There are projects where the data team needs to run data processing for large volumes, running locally can be a very painful and time-consuming process, that's the reason to use Fargate for processing large data sets or a EC2 with all application installed


Similar project: https://github.com/developmentseed/aws-batch-example


**Prerequisites**

Export all required parameters and obtain the AWS Account ID

```sh
export PROJECT=ffda-poi
export CLIENT=ffda
export OWNER=username

export STACK_NAME=ffda-poi-supertiles

export ECR_REPOSITORY=ffda-poi/supertiles
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

export DOCKER_IMAGE=${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPOSITORY}:v1
```


## Step 1: Build your docker image and upload to ECR


- Go to your projects and build the docker image

    e.g: https://github.com/developmentseed/poi/



- Creates a repository inside the specified namespace in the default registry for an account.

```bash
    aws ecr create-repository --repository-name ${ECR_REPOSITORY}
    aws ecr describe-repositories | jq .repositories[].repositoryName
```



- Tag your docker image in the format the needs to be upload to ECR

    e.g: from :https://github.com/developmentseed/poi/blob/main/docker-compose.yaml#L4

```bash
    docker tag ffda/poi_data:v1 ${DOCKER_IMAGE}
```

- login to ECR and push the image to ECR


```bash

    aws ecr get-login-password --region us-east-1 | docker login \
        --username AWS \
        --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

    docker push ${DOCKER_IMAGE}
```


## Step 2: Create stack

- Cluster + Fargate

```bash
    ./stack.sh <CPU> <MEMORY>
```

Some examples of values: https://docs.amazonaws.cn/en_us/AmazonECS/latest/APIReference/API_TaskDefinition.html

```
256 (.25 vCPU) - Available memory values: 512 (0.5 GB), 1024 (1 GB), 2048 (2 GB)
512 (.5 vCPU) - Available memory values: 1024 (1 GB), 2048 (2 GB), 3072 (3 GB), 4096 (4 GB)
1024 (1 vCPU) - Available memory values: 2048 (2 GB), 3072 (3 GB), 4096 (4 GB), 5120 (5 GB), 6144 (6 GB), 7168 (7 GB), 8192 (8 GB)
2048 (2 vCPU) - Available memory values: Between 4096 (4 GB) and 16384 (16 GB) in increments of 1024 (1 GB)
4096 (4 vCPU) - Available memory values: Between 8192 (8 GB) and 30720 (30 GB) in increments of 1024 (1 GB)
```

E.g

```bash
    ./stack.sh 256 512
```

*note*: in case we need a ec2 stack follow 👉 [EC2_stack.md](EC2_stack.md)

## Step 3: Execute fargate task

- Install script in order to use everywhere on the system.


`sudo cp run_task.sh /usr/local/bin/run_task` or `sudo cp run_task.sh /usr/bin/run_task`


```sh
run_task  \
    super_tiles \
        --geojson_file=s3://ds-data-projects/data_test/schools.geojson \
        --zoom=18 \
        --url_map_service="https://tile.openstreetmap.org/{z}/{x}/{y}.png" \
        --url_map_service_type=tms \
        --tiles_folder=s3://ds-data-projects/data_test/tiles \
        --st_tiles_folder=s3://ds-data-projects/data_test/super_tiles \
        --geojson_output=s3://ds-data-projects/data_test/schools_training.geojson \
        --geojson_output_coverage=s3://ds-data-projects/schools_training_coverage.geojson
```


## Step 4: Delete stack


```bash
    aws cloudformation delete-stack --stack-name ${STACK_NAME}
```