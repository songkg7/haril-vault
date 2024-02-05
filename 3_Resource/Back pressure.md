---
title: Back pressure
date: 2024-02-04 18:32:00 +0900
aliases: 
tags:
  - back-pressure
  - webflux
  - reactor
categories: 
updated: 2024-02-04 18:32:40 +0900
---

## Back pressure in Spring WebFlux



Back pressure is a concept in reactive programming that allows the consumer of a stream to control the rate at which it receives data from the producer. It ensures that the consumer does not get overwhelmed with data that it cannot process in a timely manner.

In Spring WebFlux, back pressure is handled by the Reactive Streams specification, which provides a set of interfaces and rules for implementing reactive streams. These interfaces include Publisher, Subscriber, and Subscription.

When a request is made to a WebFlux endpoint, the server creates a Publisher that emits data items as they become available. The client then subscribes to this Publisher by providing a Subscriber implementation. The Subscriber can request a certain number of items at a time using the Subscription interface.

If the client wants to control the rate at which it receives data, it can use back pressure. It does this by requesting only a certain number of items initially and then requesting more items as it processes them. This way, if the client cannot keep up with the rate of data emission, it can slow down or stop requesting more items until it catches up.

Spring WebFlux provides several ways to handle back pressure:

1. Demand-driven: The client requests data from the server using `Subscription.request()` method. The server responds by emitting only as many items as requested.
2. Buffering: The server can buffer emitted items if they are not immediately requested by the client. This allows for some tolerance in case of temporary spikes in load.
3. Dropping: If the buffer becomes full and more items are emitted by the server, some implementations may drop or discard those items to avoid overwhelming resources.
4. Error handling: If an error occurs while processing data on either side (server or client), appropriate error handling mechanisms should be put in place to handle such scenarios.

By implementing back pressure effectively, Spring WebFlux ensures efficient resource utilization and prevents overload situations where consumers are unable to keep up with the rate of data emission.

## Reference

- https://colevelup.tistory.com/40
