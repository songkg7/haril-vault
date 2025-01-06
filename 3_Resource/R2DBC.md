---
title: R2DBC
date: 2023-07-04T10:26:00
aliases: 
tags:
  - async
  - non-blocking
  - db
categories: 
updated: 2025-01-07T00:35
---

R2DBC (Reactive Relational Database Connectivity) is a specification for building non-blocking database drivers in Java. It provides an asynchronous and reactive programming model for interacting with relational databases.

Traditional JDBC (Java Database Connectivity) uses a blocking I/O model where each database operation blocks until it completes, which can lead to inefficient resource utilization and scalability issues. R2DBC, on the other hand, allows developers to write non-blocking, reactive code that can handle multiple concurrent requests efficiently.

R2DBC follows the principles of the Reactive Streams specification, which provides a standard for asynchronous stream processing with backpressure. It allows applications to handle large volumes of data streams without overwhelming resources by controlling the flow of data between the producer and consumer.

The key advantages of using R2DBC are:

1. Non-blocking: R2DBC drivers allow multiple concurrent database operations without blocking threads, enabling better resource utilization and scalability.

2. Reactive programming model: R2DBC supports reactive programming paradigms, allowing developers to write asynchronous, event-driven code that is more resilient and responsive.

3. Backpressure support: R2DBC integrates with Reactive Streams to provide backpressure handling, allowing applications to control the rate at which data is processed, preventing overload situations.

4. Standardized API: R2DBC provides a standardized API across different databases, making it easier for developers to switch between databases or use multiple databases within an application.

R2DBC has gained popularity in the Java ecosystem as it aligns well with modern application development practices that focus on scalability, responsiveness, and high throughput. It offers an alternative to traditional blocking JDBC drivers and enables developers to build efficient and scalable applications that can handle large volumes of data streams.
