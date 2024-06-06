---
title: Localstack
date: 2024-05-30 14:13:00 +0900
aliases: 
tags:
  - test
  - aws
  - sqs
categories: 
updated: 2024-06-05 22:12:16 +0900
---

## Docker compose 사용시 초기화 스크립트

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

### permission 관련 에러가 출력될 경우

```bash
chmod +x ./init-resources.sh
```

## Reference

- https://testcontainers.com/guides/testing-aws-service-integrations-using-localstack/
