---
title: 실시간 복제데이터를 이관시키는 방법
date: 2023-09-22 09:49:00 +0900
aliases: 
tags:
  - migration
  - aurora
  - postgresql
  - dynamodb
  - dynamo-streams
  - s3
  - json
  - athena
  - csv
  - cdc
categories: 
updated: 2023-09-22 09:49:56 +0900
---

## Summary

- DynamoDB streams 와 CDC 를 이용해서 데이터를 복제
- DynamoDB 는 덤프 기능을 통해 S3 로 데이터를 내보낼 수 있음
- 분석도구인 Aws Athena 를 통해 S3 에 존재하는 JSON 데이터를 조회하여 CSV 로 변환할 수 있음
- Aurora 의 기능 중 하나는 S3 에 존재하는 CSV 파일로 테이블을 구성할 수 있다는 것(내부적으로 [[PostgreSQL]]의 Copy 기능을 통해 구현됨). 이 기능을 활용하여 덤프작업을 완료
- 일시정지해두었던 DynamoDB streams 를 재가동하면 덤프 작업 시간 동안 쌓였던 CDC 가 대상 DB 에 반영되며 데이터의 싱크가 맞게 되고 최종적으로 데이터 이관 작업이 완료

## Reference

- [실시간 복제데이터를 이관시키는 방법](https://medium.com/stayge-labs/%EC%8B%A4%EC%8B%9C%EA%B0%84-%EB%B3%B5%EC%A0%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%A5%BC-%EC%9D%B4%EA%B4%80%EC%8B%9C%ED%82%A4%EB%8A%94-%EB%B0%A9%EB%B2%95-498d3d52c8b4)
