---
title: "Event Loop"
date: 2023-01-11 18:32:00 +0900
aliases: 
tags: [webflux, reactive, reactor]
categories: 
---

## Overview

single thread 를 사용하여 대량의 트래픽을 처리하기 위한 reactive 처리 방식

Event Loop 는 중단되지 않고 실행되는 상태로 존재하다가 event 가 들어오면 요청을 보내고 바로 반환한다? event 에 대한 결과가 처리되면 다시 반환?

하나의 event 는 event 의 라이프사이클동안은 같은 thread 안에서 동작한다.
 