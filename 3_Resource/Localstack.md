---
title: Localstack
date: 2024-05-30T14:13:00
aliases: 
tags:
  - test
  - aws
  - sqs
categories: 
updated: 2025-01-07T00:35
---

## Docker compose 사용시 초기화 스크립트

[[docker|Docker]]

```yaml
volumes:
  - '.localstack-init/init-resources.sh:/etc/localstack/init/ready.d/init-resources.sh'
```

```bash
#!/bin/sh
echo "Init localstack"
awslocal s3 mb s3://test-bucket
awslocal sqs create-queue --queue-name test-queue
```

### Permission 관련 에러가 출력될 경우

```bash
chmod +x ./init-resources.sh
```

## Reference

- https://testcontainers.com/guides/testing-aws-service-integrations-using-localstack/
