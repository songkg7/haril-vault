---
title: "Arc"
date: 2023-04-06 20:27:00 +0900
aliases: 
tags: [arc, browser, chromium, awesome]
categories: 
---

%%draft: 2023-04-06%%

[[Chromium]] 기반의 모던한 웹 브라우저

23년 4월 기준 클로즈 베타

```bash
brew install --cask arc
```

간단히 사용해보며 느낀 점

## Pros

- 유려한 디자인
- 뛰어난 UX, [[Chrome]] 에 비해 가벼우면서도 사용성이 좋음
- UI 의 많은 부분을 커스텀할 수 있음
    - 심지어 특정 웹페이지조차 커스텀 가능(!)하여 wiki 사이트의 색상을 커스텀해버린다던가 하는 행위가 가능
- Auto Archive
    - 특정 시간동안 활동이 없는 페이지를 자동으로 닫아서 항상 깔끔한 UI 를 유지하게끔 유도함, 물론 필요할 경우 다시 확인할 수 있음
- Split view
- default adblock
- popup

## Cons

- profile, preference, password 공유 미지원 (추가 예정)
    - [!] 한 기기에서 설정했던 secret key 를 다른 기기에서 공유되지 않아 쓸 수 없음, safari 나 chrome 의 경우 자연스럽게 연동되어 서로 다른 기기여도 하나의 기기처럼 사용할 수 있음
- [[Vimium]] 과 일부 단축키 호환이 자연스럽지 않음

## Conclusion

정식 출시되면 [[Chrome]]을 더 이상 사용할 필요가 없을 정도로 뛰어난 브라우저가 될 것이라 기대된다. 클로즈 베타지만 이미 UI/UX 가 압도적으로 뛰어나다는 느낌을 받을 정도로 편리했음.

## Reference

- [Arc](https://arc.net/)
