---
title: Elasticsearch
date: 2022-10-03 17:39:00 +0900
aliases: ES
tags:
  - elasticsearch
  - nosql
  - search-engine
  - elk
categories: Elasticsearch
updated: 2023-08-19 12:38:08 +0900
---

아파치 루씬을 베이스로 하는 검색 엔진. no sql DB 로도 활용할 수 있다. 역색인을 사용하여 검색을 최적화하고, 클러스터링을 통해 대량의 데이터 처리를 가능하게 한다.

[[Logstash]], [[Kibana]] 등 elastic 재단의 다른 툴과 연동성이 제공된다.

## What is Elasticsearch?

Elasticsearch is a search engine based on Apache Lucene that can also be used as a NoSQL database. It uses inverted indexing to optimize searches and enables the processing of massive amounts of data through clustering. Elasticsearch has seamless integration with other tools from the Elastic Stack, including Logstash and Kibana.

As a search engine, Elasticsearch allows users to search through large amounts of data quickly and efficiently. It can handle structured, unstructured, and semi-structured data, making it a versatile tool for a variety of applications. In addition to its search capabilities, Elasticsearch can also be used as a NoSQL database for storing and retrieving data.

One of the key features of Elasticsearch is its use of inverted indexing. This technique involves creating an index that maps each term in the dataset to the documents that contain it. This allows for fast and accurate searches, even on large datasets.

Elasticsearch also supports clustering, which enables it to process massive amounts of data in parallel across multiple nodes. This makes it an ideal choice for applications that require real-time search or analytics on large datasets.

In addition to its core functionality, Elasticsearch has a number of features that make it easy to use and integrate with other tools. For example, the Elastic Stack includes Logstash for collecting and processing log data, and Kibana for visualizing and analyzing data from Elasticsearch.

Overall, Elasticsearch is a powerful tool for searching and analyzing large datasets. Its flexibility and scalability make it an ideal choice for a wide range of applications, from e-commerce sites to enterprise search platforms.
