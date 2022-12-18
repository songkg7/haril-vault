---
title: "MongoDB 배포시 고려사항"
date: 2022-12-18 19:11:00 +0900
aliases: 
tags: [mongodb, nosql]
categories: MongoDB
---

Write 요청이 압도적으로 많은 서비스: Sharded Cluster
Replica Set 은 write 에 대한 분산이 불가능하다.

논리적인 데이터베이스가 많은 경우: 영구적으로 데이터를 보관해야한다고 할 때 매일 1GB 씩 데이터가 증가하는 경우는 여러 Replica Set 으로 분리

## Conclusion

가능하면 Replica Set 으로 배포하되, Replica Set 으로 요구사항을 만족하지 못할 때 Sharded Cluster 를 고려한다.