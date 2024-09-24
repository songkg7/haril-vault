---
title: Paper Reading Study
date: 2024-06-18 11:17:00 +0900
aliases: 
tags:
  - study
  - paper
categories: 
updated: 2024-06-18 13:40:41 +0900
---

1. **Dynamo - Amazon’s Highly Available Key Value Store**:

- Dynamo 시스템이 Amazon의 대규모 환경에서 어떻게 신뢰성을 제공하는지, 그리고 일관성을 희생하면서 어떻게 항상 사용 가능한 경험을 지원하는지에 대해 다룹니다. 
- [https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf?utm_source=substack&utm_medium=email](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf?utm_source=substack&utm_medium=email)

2. **Google File System:**

- Google File System의 설계 및 구현에 초점을 맞추며, 이 시스템이 대규모 데이터 중심 응용 프로그램을 지원하는 분산 파일 시스템으로서 어떻게 Scalability 와 Fault Tolerance 를 제공하는지에 대해 다룹니다. 
- [https://static.googleusercontent.com/media/research.google.com/en//archive/gfs-sosp2003.pdf?utm_source=substack&utm_medium=email](https://static.googleusercontent.com/media/research.google.com/en//archive/gfs-sosp2003.pdf?utm_source=substack&utm_medium=email)

3. **Scaling Memcached at Facebook**:

- Facebook 이 Memcached 를 활용하여 어떻게 전 세계에서 가장 큰 소셜 네트워크를 지원하는 분산 키-값 저장소를 구축하고 확장했는지에 대해 다룹니다. 
- [https://www.usenix.org/system/files/conference/nsdi13/nsdi13-final170_update.pdf](https://www.usenix.org/system/files/conference/nsdi13/nsdi13-final170_update.pdf)

4. **BigTable:**

- Bigtable이 어떻게 구조화된 데이터를 관리하기 위해 설계되었으며, 수천 대의 commodity servers 에서 페타바이트 규모로 확장될 수 있는지에 대해 다룹니다. 
- [https://substack.com/redirect/c49ce9b7-e0ab-4f1e-8936-3efd383ba713?j=eyJ1IjoiMmNscmc3In0.K_gP_5CqaAf0cWWggPM-WMz4gPJ_QSJ7yEFtqH8EWp4](https://substack.com/redirect/c49ce9b7-e0ab-4f1e-8936-3efd383ba713?j=eyJ1IjoiMmNscmc3In0.K_gP_5CqaAf0cWWggPM-WMz4gPJ_QSJ7yEFtqH8EWp4)

5. **Borg - Large Scale Cluster Management at Google**: 

- Borg 시스템이 수십만 대의 기계를 포함하는 여러 클러스터에서 수천 개의 다양한 응용 프로그램에서 수백만 개의 작업을 어떻게 관리하는지, 그리고 높은 자원 활용도를 달성하기 위해 어떤 기술을 사용하는지에 대해 다룹니다. 
- [https://storage.googleapis.com/pub-tools-public-publication-data/pdf/43438.pdf?utm_source=substack&utm_medium=email](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/43438.pdf?utm_source=substack&utm_medium=email)

6. **Cassandra:**

- Cassandra 가 어떻게 대량의 구조화된 데이터를 여러 커머디티 서버에 걸쳐 관리하면서, 단일 실패 지점 없이 높은 가용성을 제공하는 분산 스토리지 시스템이 될 수 있는지에 대해 다룹니다. 
- [https://substack.com/redirect/cad644f7-a5c8-4d78-9b37-75597bf3b689?j=eyJ1IjoiMmNscmc3In0.K_gP_5CqaAf0cWWggPM-WMz4gPJ_QSJ7yEFtqH8EWp4](https://substack.com/redirect/cad644f7-a5c8-4d78-9b37-75597bf3b689?j=eyJ1IjoiMmNscmc3In0.K_gP_5CqaAf0cWWggPM-WMz4gPJ_QSJ7yEFtqH8EWp4)

7. **Attention Is All You Need:** 

- 기존의 복잡한 순환 또는 합성곱 신경망을 대체하는 새로운 신경망 구조인 Transformer 에 대해 설명하며, 이 구조가 어떻게 오직 Attention 메커니즘만을 기반으로 하여 더 빠른 학습 속도와 높은 병렬 처리 능력을 제공하는지에 대해 다룹니다. 
- [https://arxiv.org/abs/1706.03762?utm_source=substack&utm_medium=email](https://arxiv.org/abs/1706.03762?utm_source=substack&utm_medium=email)

8. **Kafka:**

- Kafka가 어떻게 대량의 로그 데이터를 수집하고 낮은 지연시간으로 전달하는 분산 메시징 시스템인지, 그리고 기존 로그 집계기 및 메시징 시스템에서 어떤 아이디어를 도입했는지에 대해 다룹니다.
- [https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/Kafka.pdf?utm_source=substack&utm_medium=email](https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/Kafka.pdf?utm_source=substack&utm_medium=email) 

9. **FoundationDB:**

- FoundationDB 가 어떻게 NoSQL의 유연성과 확장성을 ACID 트랜잭션과 결합하고 있는지, 그리고 이 시스템이 어떻게 분리된 아키텍처를 채택하여 각 서브시스템을 독립적으로 조정할 수 있게 만들었는지에 대해 다룹니다. 
- [https://www.foundationdb.org/files/fdb-paper.pdf?utm_source=substack&utm_medium=email](https://www.foundationdb.org/files/fdb-paper.pdf?utm_source=substack&utm_medium=email)

10. **Amazon Aurora**:

- Aurora가 어떻게 OLTP 워크로드를 위한 관계형 데이터베이스 서비스로 설계되었으며, 고성능 데이터 처리에 있어 네트워크가 중요한 제약 요소로 부상했는지에 대해 다룹니다. 
- [https://web.stanford.edu/class/cs245/readings/aurora.pdf?utm_source=substack&utm_medium=email](https://web.stanford.edu/class/cs245/readings/aurora.pdf?utm_source=substack&utm_medium=email)

11. **Spanner:** 

- Spanner가 어떻게 세계적 규모로 데이터를 분산시키고, externally-consistent 을 지원하는 분산 트랜잭션을 처음으로 제공하는 시스템인지에 대해 다룹니다. 
- [https://static.googleusercontent.com/media/research.google.com/en//archive/spanner-osdi2012.pdf?utm_source=substack&utm_medium=email](https://static.googleusercontent.com/media/research.google.com/en//archive/spanner-osdi2012.pdf?utm_source=substack&utm_medium=email)

12. **MapReduce:**

- MapReduce가 어떻게 대규모 데이터 세트를 처리하고 생성하는데 사용되며, 사용자가 맵 함수와 리듀스 함수를 정의하여 데이터를 자동으로 병렬 처리하는 방식에 대해 다룹니다. 
- [https://storage.googleapis.com/pub-tools-public-publication-data/pdf/16cb30b4b92fd4989b8619a61752a2387c6dd474.pdf?utm_source=substack&utm_medium=email](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/16cb30b4b92fd4989b8619a61752a2387c6dd474.pdf?utm_source=substack&utm_medium=email)

13. **Shard Manager**:

- Shard Manager 가 어떻게 지리적으로 분산된 애플리케이션을 위한 샤드 관리를 단순화하고, 소프트웨어 업그레이드와 같은 계획된 이벤트 동안 애플리케이션 가용성을 유지하는 기능을 제공하는지에 대해 다룹니다. 
- [https://dl.acm.org/doi/pdf/10.1145/3477132.3483546?utm_source=substack&utm_medium=email](https://dl.acm.org/doi/pdf/10.1145/3477132.3483546?utm_source=substack&utm_medium=email)

14. **Dapper**:

- Dapper가 어떻게 낮은 오버헤드, 애플리케이션 수준의 투명성을 제공하며 대규모 시스템에서 어디에나 배포될 수 있는지에 대해 다룹니다. 
- [https://static.googleusercontent.com/media/research.google.com/en//archive/papers/dapper-2010-1.pdf?utm_source=substack&utm_medium=email](https://static.googleusercontent.com/media/research.google.com/en//archive/papers/dapper-2010-1.pdf?utm_source=substack&utm_medium=email)

15. **Flink**:

- Apache Flink 시스템의 주요 특징과 철학을 소개하고, Flink가 실시간 분석, 연속 데이터 파이프라인, 이력 데이터 처리(배치), 반복적 알고리즘(머신러닝, 그래프 분석)을 포함한 다양한 데이터 처리 응용 프로그램을 지원하는지에 대해 다룹니다. 
- [https://www.researchgate.net/publication/308993790_Apache_Flink_Stream_and_Batch_Processing_in_a_Single_Engine](https://www.researchgate.net/publication/308993790_Apache_Flink_Stream_and_Batch_Processing_in_a_Single_Engine)

16. **A Comprehensive Survey on Vector Databases:**

- 벡터 데이터베이스에 관한 포괄적인 내용을 다룹니다. 그리고 벡터 데이터베이스가 고차원 데이터를 저장하는 방법, 전통적인 DBMS에서 다루기 어려운 데이터의 특성화 방법, 그리고 이 분야에서 발생하는 주요 도전 과제들에 대해 다룹니다. 
- [https://arxiv.org/pdf/2310.11703](https://arxiv.org/pdf/2310.11703)

17. **Zanzibar:**

- 구글의 Zanzibar 시스템에 대해 다룹니다. 그리고 Zanzibar가 어떻게 수조 개의 접근 제어 목록과 초당 수백만 개의 인증 요청을 처리하는지에 대해 다룹니다. 
- [https://storage.googleapis.com/pub-tools-public-publication-data/pdf/10683a8987dbf0c6d4edcafb9b4f05cc9de5974a.pdf?utm_source=substack&utm_medium=email](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/10683a8987dbf0c6d4edcafb9b4f05cc9de5974a.pdf?utm_source=substack&utm_medium=email)

18. **Monarch:** 

- 구글의 Monarch가 어떻게 전 세계적으로 분산된 인메모리 시계열 데이터베이스로서 구글의 수십억 사용자 규모의 애플리케이션과 시스템을 모니터링하는 데 사용되는지, 그리고 이 시스템이 매초 테라바이트의 데이터를 수집하고 수백만 건의 쿼리를 처리하는 방법에 대해 다룹니다. 
- [https://storage.googleapis.com/pub-tools-public-publication-data/pdf/d84ab6c93881af998de877d0070a706de7bec6d8.pdf?utm_source=substack&utm_medium=email](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/d84ab6c93881af998de877d0070a706de7bec6d8.pdf?utm_source=substack&utm_medium=email)

19. **Thrift**:

- Thrift 소프트웨어 라이브러리와 코드 생성 도구에 대해 다룹니다. 그리고 Thrift가 어떻게 다양한 프로그래밍 언어 간의 효율적이고 신뢰할 수 있는 통신을 가능하게 하는지에 대해 다룹니다. 
- [https://thrift.apache.org/static/files/thrift-20070401.pdf?utm_source=substack&utm_medium=email](https://thrift.apache.org/static/files/thrift-20070401.pdf?utm_source=substack&utm_medium=email)

20. **Bitcoin:**

- 비트코인이 금융기관을 거치지 않고 직접적으로 온라인 지불을 가능하게 하는 순수한 Peer-to-Peer 전자화폐 시스템으로서, 어떻게 이중 지불 문제를 해결하며, 해시 기반의 작업 증명을 통해 거래를 타임스탬프하는 네트워크를 사용하는지에 대해 다룹니다. 
- [https://bitcoin.org/bitcoin.pdf?utm_source=substack&utm_medium=email](https://bitcoin.org/bitcoin.pdf?utm_source=substack&utm_medium=email)

21. **WTF - Who to Follow Service at Twitter**:

- WTF가 어떻게 일일 수백만 사용자 간의 연결을 생성하는지, 그리고 공유된 관심사, 공통 연결 등을 기반으로 어떻게 사용자 추천을 수행하는지에 대해 다룹니다. 
- [https://web.stanford.edu/~rezab/papers/wtf_overview.pdf?utm_source=substack&utm_medium=email](https://web.stanford.edu/~rezab/papers/wtf_overview.pdf?utm_source=substack&utm_medium=email)

22. **MyRocks: LSM-Tree Database Storage Engine**:

- Facebook 에서 MyRocks 엔진을 어떻게 활용하는지에 대해 다룹니다. 그리고 MyRocks가 어떻게 LSM-트리 기반의 RocksDB 위에 구축되어 MySQL의 관계형 기능을 통합했는지에 대해서도 다룹니다. 
- [https://www.vldb.org/pvldb/vol13/p3217-matsunobu.pdf?utm_source=substack&utm_medium=email](https://www.vldb.org/pvldb/vol13/p3217-matsunobu.pdf?utm_source=substack&utm_medium=email)

23. **GoTo Considered Harmful:** 

- [https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf?utm_source=substack&utm_medium=email](https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf?utm_source=substack&utm_medium=email)

24. **Raft Consensus Algorithm:**

- Raft 합의 알고리즘에 대해 다룹니다. 그리고 Raft가 어떻게 Paxos와 동등한 결과를 내면서도 더 이해하기 쉽고 실용적인 시스템 구축의 기반을 제공하는지에 대해서도 다룹니다. 
- [https://raft.github.io/raft.pdf?utm_source=substack&utm_medium=email](https://raft.github.io/raft.pdf?utm_source=substack&utm_medium=email)

25. **Time Clocks and Ordering of Events**:

- 분산 시스템 내에서 이벤트의 순서를 결정하고 시간의 개념을 이해하는 방법에 대해 다룹니다. 
- [https://lamport.azurewebsites.net/pubs/time-clocks.pdf?utm_source=substack&utm_medium=email](https://lamport.azurewebsites.net/pubs/time-clocks.pdf?utm_source=substack&utm_medium=email)

## Reference

- https://careerly.co.kr/comments/104598
