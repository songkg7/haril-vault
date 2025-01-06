---
title: AWS ECS and Grafana Loki Integration
date: 2024-02-22T11:02:00
aliases: 
tags:
  - log
  - observability
  - grafana
  - ecs
categories: 
updated: 2025-01-07T00:35
---

AWS ECS 의 로그를 Grafana [[Loki]] 로 보내기 위해 작성

```json
{
    "taskDefinitionArn": "arn:aws:ecs:ap-northeast-2:842253897914:task-definition/svmp-api-carrier-dev:4",
    "containerDefinitions": [
        {
            "name": "svmp-api-carrier-dev",
            "image": "842253897914.dkr.ecr.ap-northeast-2.amazonaws.com/svmp-api-carrier:latest",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "svmp-api-carrier-dev-8080-tcp",
                    "containerPort": 8080,
                    "hostPort": 8080,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [],
            "mountPoints": [],
            "volumesFrom": [],
            "dockerLabels": {
                "env": "dev"
            },
            "logConfiguration": {
                "logDriver": "awsfirelens",
                "options": {
                    "Name": "cloudwatch",
                    "auto_create_group": "true",
                    "log_group_name": "firelens-fluent-bit",
                    "log_stream_prefix": "from-fluent-bit",
                    "region": "ap-northeast-2"
                }
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "wget --no-verbose --tries=1 --spider localhost:8080/actuator/health || exit 1"
                ],
                "interval": 30,
                "timeout": 5,
                "retries": 3,
                "startPeriod": 10
            }
        },
        {
            "name": "log-router",
            "image": "906394416424.dkr.ecr.ap-northeast-2.amazonaws.com/aws-for-fluent-bit:stable",
            "cpu": 0,
            "memoryReservation": 50,
            "portMappings": [],
            "essential": true,
            "environment": [],
            "mountPoints": [],
            "volumesFrom": [],
            "user": "0",
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "firelens-container",
                    "awslogs-region": "ap-northeast-2",
                    "awslogs-stream-prefix": "firelens"
                }
            },
            "firelensConfiguration": {
                "type": "fluentbit",
                "options": {
                    "config-file-type": "file",
                    "config-file-value": "/fluent-bit/configs/parse-json.conf"
                }
            }
        }
    ],
    "family": "svmp-api-carrier-dev",
    "taskRoleArn": "arn:aws:iam::842253897914:role/svmp-ecs-task-test-role",
    "executionRoleArn": "arn:aws:iam::842253897914:role/svmp-ecs-task-test-role",
    "networkMode": "awsvpc",
    "revision": 4,
    "volumes": [],
    "status": "ACTIVE",
    "requiresAttributes": [
        {
            "name": "ecs.capability.execution-role-awslogs"
        },
        {
            "name": "com.amazonaws.ecs.capability.ecr-auth"
        },
        {
            "name": "ecs.capability.firelens.options.config.file"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.17"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.21"
        },
        {
            "name": "com.amazonaws.ecs.capability.logging-driver.awsfirelens"
        },
        {
            "name": "com.amazonaws.ecs.capability.task-iam-role"
        },
        {
            "name": "ecs.capability.container-health-check"
        },
        {
            "name": "ecs.capability.execution-role-ecr-pull"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
        },
        {
            "name": "ecs.capability.task-eni"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.29"
        },
        {
            "name": "com.amazonaws.ecs.capability.logging-driver.awslogs"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.19"
        },
        {
            "name": "ecs.capability.firelens.fluentbit"
        }
    ],
    "placementConstraints": [],
    "compatibilities": [
        "EC2",
        "FARGATE"
    ],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "1024",
    "memory": "2048",
    "runtimePlatform": {
        "cpuArchitecture": "ARM64",
        "operatingSystemFamily": "LINUX"
    },
    "registeredAt": "2024-02-27T02:06:18.556Z",
    "registeredBy": "arn:aws:iam::842253897914:user/kyunggeun.song",
    "tags": []
}
```

```json
{
    "name": "log-router",
    "image": "906394416424.dkr.ecr.ap-northeast-2.amazonaws.com/aws-for-fluent-bit:stable",
    "cpu": 0,
    "memoryReservation": 50,
    "essential": true,
    "user": "0",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "firelens-container",
            "awslogs-region": "{aws-region}",
            "awslogs-stream-prefix": "firelens"
        }
    },
    "firelensConfiguration": {
        "type": "fluentbit",
        "options": {
            "config-file-type": "file",
            "config-file-value": "/fluent-bit/configs/parse-json.conf"
        }
    }
}
```

## Reference

- https://medium.com/@kvendingoldo/aws-ecs-and-loki-integration-aae324456d7f
- https://grafana.com/blog/2020/08/06/loki-tutorial-how-to-send-logs-from-amazons-ecs-to-loki/
- https://khalti.engineering/implementing-aws-firelens-with-grafana-loki-in-aws-ecs
