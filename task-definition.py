import json
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--task_definition")
parser.add_argument("--ecr_repository")
parser.add_argument("--account_id")

args = parser.parse_args()
task_definition = args.task_definition
ecr_repository = args.ecr_repository
account_id = args.account_id

task_definition_config = {
    "family": task_definition,
    "executionRoleArn": f"arn:aws:iam::{account_id}:role/ecsTaskExecutionRole",
    "containerDefinitions": [{
        "name": task_definition,
        "image": f"{account_id}.dkr.ecr.us-east-1.amazonaws.com/{ecr_repository}:v1",
        "environment": [{
                        "name": "TEST",
                        "value": "test"
                        }],
        "essential": True,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": f"/ecs/{task_definition}",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }],
    "memory": "8192",
    "cpu": "4096",
    "taskRoleArn": f"arn:aws:iam::{account_id}:role/ecsS3FullAccess",
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "networkMode": "awsvpc"}

print(json.dumps(task_definition_config, indent=4))
