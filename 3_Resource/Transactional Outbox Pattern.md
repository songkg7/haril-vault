---
title: Transactional Outbox Pattern
date: 2023-07-10 11:15:00 +0900
aliases: 
tags:
  - distribute
  - transaction
categories: 
updated: 2024-02-06 21:22:06 +0900
---

The Transactional Outbox Pattern is a design pattern used in distributed systems to ensure reliable message delivery. It is often used in systems where multiple services need to be notified of changes or events.

In a distributed system, it is common for services to communicate with each other by sending messages. These messages can be used to notify other services of changes or events that have occurred. However, sending messages directly from one service to another can introduce certain challenges.

One challenge is that the sending service might crash or experience downtime before the message is successfully delivered. This could result in the message being lost and the receiving service not being notified of the change or event. Another challenge is that if the sending service retries sending the message after a failure, it might end up duplicating the message and causing unintended side effects.

The Transactional Outbox Pattern addresses these challenges by introducing an outbox table in the database of the sending service. Whenever a change or event occurs that requires notification to other services, instead of immediately sending a message, the sending service writes an entry into its outbox table.

The outbox table contains all the necessary information to construct and send a message, such as the recipient's address and any relevant data. It also includes a flag indicating whether the message has been successfully sent.

During regular transactional processing, after committing changes to the database, the sending service also checks its outbox table for any unsent messages. It then sends these messages using a separate background process or worker thread.

If an error occurs during message delivery, such as network issues or recipient service downtime, the background process can retry delivery without affecting normal transactional processing. Once a message has been successfully delivered, it is marked as sent in the outbox table to prevent duplication.

In addition to ensuring reliable message delivery, the Transactional Outbox Pattern also provides benefits such as decoupling between services and improved performance by avoiding synchronous communication between services.

Overall, the Transactional Outbox Pattern is a powerful tool for designing distributed systems that require reliable message delivery. By using an outbox table and background processing, it enables services to communicate asynchronously while maintaining data consistency and avoiding message loss or duplication.

## Reference

- [강남언니 공식 기술블로그](https://blog.gangnamunni.com/post/transactional-outbox)
- [동인님 블로그](https://velog.io/@eastperson/Transaction-Outbox-Pattern-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0)
- [RIDI 블로그](https://ridicorp.com/story/transactional-outbox-pattern-ridi/)
