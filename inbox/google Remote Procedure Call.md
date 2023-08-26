---
title: gRPC
date: 2023-08-26 12:41:00 +0900
aliases: gRPC
tags: network, http
categories: null
updated: 2023-08-27 00:00:27 +0900
---

특징

- HTTP/2
- Protocol Buffer

- protobuf 를 이용해 JSON 보다 좋은 성능
- 명확한 서비스 인터페이스 스키마
- 스트리밍 지원
- 내장 기능 풍부(인증, 암호화, 압축 등)

![[Pasted image 20230827000117.png]]

gRPC Client 는 resolver 와 LB 를 들고 있다.

![[Pasted image 20230827000806.png]]

![[Pasted image 20230827000844.png]]

## Reference

- [Naver Cloud Platform Tech Blog](https://medium.com/naver-cloud-platform/nbp-%EA%B8%B0%EC%88%A0-%EA%B2%BD%ED%97%98-%EC%8B%9C%EB%8C%80%EC%9D%98-%ED%9D%90%EB%A6%84-grpc-%EA%B9%8A%EA%B2%8C-%ED%8C%8C%EA%B3%A0%EB%93%A4%EA%B8%B0-1-39e97cb3460)
- [당근마켓](https://www.youtube.com/watch?v=igHrQPzLVRw&t=36s)

## Links
