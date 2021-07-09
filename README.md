# Execute data processing tasks in Fargate

This repo aims to execute any docker container in Fargate. 

**Why was this repo created?**

There are projects where the data-team needs to run certain data processing, for large datasets  running in local can be very painful and time consuming time process,   that is the reason to use Fargate  for large datasets processing.

Similar project: https://github.com/developmentseed/aws-batch-example


**Prerequisites**

Export all required parameters and obtain the AWS Account ID

```sh
export PROJECT=ffda-poi
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
    aws ecr describe-repositories
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

```bash
    ./cloudformation.sh
```


## Step 3: Execute task

```sh
./run_task.sh  \
    super_tiles \
        --geojson_file=s3://ds-data-projects/FFDA/phase3/training_data/mauritania_training_data.geojson \
        --zoom=18 \
        --url_map_service=https://tile.openstreetmap.org/{z}/{x}/{y}.png \
        --url_map_service_type=tms \
        --tiles_folder=data/tiles \
        --st_tiles_folder=s3://ffda-poi/training_data/mauritania_test/supertiles/ \
        --geojson_output=s3://ffda-poi/training_data/mauritania_test/mauritania_training_data.geojson \
        --geojson_output_coverage=s3://ffda-poi/training_data/mauritania_test/mauritania_training_supertile_coverage.geojson
```

## Step 4: Delete stack


```bash
    aws cloudformation delete-stack --stack-name ${STACK_NAME}
```