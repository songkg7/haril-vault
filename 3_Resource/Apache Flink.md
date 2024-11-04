---
title: Apache Flink
date: 2024-10-08 09:31:00 +0900
aliases: 
tags:
  - streaming
  - flink
categories: 
description: 
updated: 2024-10-29 13:41:34 +0900
---

```java
// 1. Spring Cloud Stream을 사용한 주문 이벤트 처리
@Configuration
public class OrderStreamConfig {
    @Bean
    public Function<Message<Order>, Message<OrderEvent>> processOrder() {
        return message -> {
            Order order = message.getPayload();
            // 기본적인 주문 처리 및 검증
            OrderEvent orderEvent = OrderEvent.builder()
                .orderId(order.getId())
                .userId(order.getUserId())
                .amount(order.getAmount())
                .timestamp(Instant.now())
                .build();
            
            // Kafka로 이벤트 전송
            return MessageBuilder.withPayload(orderEvent)
                .build();
        };
    }
}

// 2. Apache Flink를 사용한 복잡한 분석 처리
public class OrderAnalytics {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        
        // Kafka에서 주문 이벤트 스트림 생성
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        properties.setProperty("group.id", "order-analytics");
        
        FlinkKafkaConsumer<OrderEvent> consumer = new FlinkKafkaConsumer<>(
            "order-events",
            new OrderEventDeserializationSchema(),
            properties
        );
        
        DataStream<OrderEvent> orderStream = env.addSource(consumer);
        
        // 1분 단위 윈도우로 집계
        DataStream<UserActivityAnalytics> userAnalytics = orderStream
            .keyBy(OrderEvent::getUserId)
            .window(TumblingEventTimeWindows.of(Time.minutes(1)))
            .aggregate(new OrderAggregator());
        
        // 사기 거래 탐지를 위한 패턴 매칭
        Pattern<OrderEvent, ?> fraudPattern = Pattern.<OrderEvent>begin("first")
            .where(new SimpleCondition<OrderEvent>() {
                @Override
                public boolean filter(OrderEvent event) {
                    return event.getAmount() > 1000;
                }
            })
            .next("second")
            .where(new SimpleCondition<OrderEvent>() {
                @Override
                public boolean filter(OrderEvent event) {
                    return event.getAmount() > 1000;
                }
            })
            .within(Time.minutes(5));
        
        PatternStream<OrderEvent> patternStream = CEP.pattern(
            orderStream.keyBy(OrderEvent::getUserId),
            fraudPattern
        );
        
        // 의심스러운 거래 탐지 시 알림
        DataStream<FraudAlert> fraudAlerts = patternStream.select(
            (Map<String, List<OrderEvent>> pattern) -> {
                OrderEvent first = pattern.get("first").get(0);
                OrderEvent second = pattern.get("second").get(0);
                
                return new FraudAlert(
                    first.getUserId(),
                    Arrays.asList(first.getOrderId(), second.getOrderId()),
                    Instant.now()
                );
            }
        );
        
        // 분석 결과를 다시 Kafka로 전송
        FlinkKafkaProducer<FraudAlert> fraudAlertProducer = new FlinkKafkaProducer<>(
            "fraud-alerts",
            new FraudAlertSerializationSchema(),
            properties
        );
        
        fraudAlerts.addSink(fraudAlertProducer);
        
        env.execute("Order Analytics Job");
    }
}
```

## Reference

- [Jeremy's Blog | Apache Flink - Hello, World!](https://sungjk.github.io/2024/09/18/apache-flink.html)