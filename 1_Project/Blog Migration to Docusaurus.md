---
title: Blog Migration to Docusaurus
date: 2024-05-02 16:47:00 +0900
aliases: 
tags: 
categories: 
updated: 2024-05-06 13:05:30 +0900
---

- [[Jekyll]] 이 자유도가 높지 않고, 버전업그레이드나 전체적으로 관리하기 어렵다는 느낌이 계속 들어 [[Docusaurus]] 로 마이그레이션을 시도
- [[O2]] 의 이슈 중 docusaurus 를 지원해달라는 이슈가 있음 - https://github.com/songkg7/o2/discussions/346
- 24년 4월에 발생한 Jdelivery CDN 이슈가 블로그를 망가트림

docusaurus 를 한 번도 사용해보지 않아 지원기능을 만들기 애매했던 점 등 종합적인 이유들로 블로그를 마이그레이션하기로 했다.

### TO-DO

- [ ] O2 에서 docusaurus 를 지원할 수 있도록 기능 추가하기 🛫 2024-05-02 ⏫
    - [ ] blog/2024-05-05/index.md 로 문서를 옮기고 리소스를 같은 디렉토리로 옮기면 깔끔
    - [ ] 포스트 이름을 무조건 index.md 로 변경하면 되기 때문에 로직 작성이 편리. title frontmatter 는 있어야 하기 때문에 없다면 파일 이름을 title 로 넣어줘야 한다
    - [ ] 같은 디렉토리에 위치하기 때문에 리소스 경로 또한 ./banner.png 처럼 깔끔하게 작성할 수 있다
- [ ] algolia 관련 이슈가 있어 contextualSearch 옵션을 true 로 할 경우 초기에는 검색 기능이 동작하지 않을 수 있다 - https://github.com/facebook/docusaurus/issues/6693
- [x] 리소스 업데이트가 빠르게 이루어지지 않는 문제
    - 커스텀 도메인 연결로 해결

### Mode

docusaurus 는 docs 와 blog 모드가 존재하며, docs 는 기술 문서에 가까운 형태를 띔. 개발 블로그는 blog mode 만 있어도 충분했기 때문에 blog only 로 설정할까 고민했음. 하지만 이럴 경우 메인 랜딩 페이지가 없어지기 때문에 뭔가 아쉬웠음.

따라서 랜딩 페이지를 유지하기 위해 blog only 는 포기하고 docs 만 다른 형태로 바꿔주기로 함

### Mermaid

플러그인 설치

### Latex

Katex 플러그인 설치

### code block highlight

java 가 기본지원이 아니기 때문에 prism 설정을 통해 java 추가. 겸사겸사 bash 도 추가해주었음.

### 커스텀 도메인 연결하기

사실 기본 깃허브 도메인을 써도 큰 지장은 없지만, 블로그를 이전하는 김에 도메인도 하나 구매해서 개발자 느낌 좀 내보려 한다.

도메인 구매

- haril.dev 로 개발자스러운 느낌의 도메인을 godaddy 에서 구매(연간 20$)
- github pages 에서 커스텀 도메인 등록을 해줘야 한다
- 기존 사용하던 도메인의 아이피 주소부터 확인하자.

```bash
dig songkg7.github.io
```

![](https://i.imgur.com/76RPRYC.png)

이 도메인 정보를

![](https://i.imgur.com/lUEshGu.png)

고대디에 등록해주자

깃허브 페이지 설정에 가서 구매한 도메인을 등록해주면

![](https://i.imgur.com/ImiE0kj.png)

설정이 끝난다.

### 추가. 도메인 verified 로 탈취 방지하기

- IP 를 추가했던 것처럼 TXT 또한 추가

![](https://i.imgur.com/PH3fifE.png)

1번이 키고 2번이 값인 느낌이다.

godaddy 로 가서 이름과 값에 위의 값들을 각각 복사해서 넣으면 된다.

![](https://i.imgur.com/eMYlw2I.png)

레코드를 추가하고 잠시 기다린 뒤 Verify 버튼을 클릭하면,

![](https://i.imgur.com/bBquRwp.png)

이렇게 도메인 인증이 완료되고 도메인 탈취 공격으로부터 보호할 수 있게 된다.

---

### Giscus 댓글

기존 컴포넌트의 디자인을 수정할 수 있다. Giscus 컴포넌트를 구현하여 추가함으로써 댓글 기능을 간단하게 구현한다.

참고: https://rikublock.dev/docs/tutorials/giscus-integration/

## Reference

- https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages
- https://rikublock.dev/docs/tutorials/giscus-integration/