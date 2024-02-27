---
title: AWS ECS and Grafana Loki Integration
date: 2024-02-22 11:02:00 +0900
aliases: 
tags:
  - log
  - observability
  - grafana
  - ecs
categories: 
updated: 2024-02-27 11:21:35 +0900
---

AWS ECS 의 로그를 Grafana [[Loki]] 로 보내기 위해 작성

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
