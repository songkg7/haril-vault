---
title: Blog Migration to Docusaurus from Jekyll
date: 2024-05-02 16:47:00 +0900
aliases: 
tags:
  - docusaurus
  - blog
  - algolia
  - react
categories: 
updated: 2024-05-11 14:56:16 +0900
---

- [[Jekyll]] 이 자유도가 높지 않고, 버전업그레이드나 전체적으로 관리하기 어렵다는 느낌이 계속 들어 [[Docusaurus]] 로 마이그레이션을 시도
    - fork 를 통해 블로그를 구성하는 특성상, github 에 잔디 기록이 남지 않아 아쉬웠음
    - Ruby 를 사용하는 부분에 있어서 인텔 맥과 애플 실리콘 맥 간 오류가 나지 않도록 주의가 필요
- [[O2]] 의 이슈 중 docusaurus 를 지원해달라는 이슈가 있음 - https://github.com/songkg7/o2/discussions/346
- 24년 4월에 발생한 Jdelivery CDN 이슈가 블로그를 망가트림
    - CDN 이슈인 이상 조금 기다리면 문제가 해결되었겠으나, 그동안 쌓인 불편으로 인해 코드를 잘못 작성했나보다고 오해하게 되었다..

docusaurus 를 한 번도 사용해보지 않아 지원기능을 만들기 애매했던 점 등 종합적인 이유들로 블로그를 마이그레이션하기로 했다.

## TO-DO

- [ ] O2 에서 docusaurus 를 지원할 수 있도록 기능 추가하기 🛫 2024-05-02 ⏫
    - [ ] blog/2024-05-05/title.md 로 문서를 옮기고 리소스를 같은 디렉토리로 옮기면 깔끔
    - [ ] 같은 디렉토리에 위치하기 때문에 리소스 경로 또한 ./banner.png 처럼 깔끔하게 작성할 수 있다
- [x] algolia 적용
    - algolia 관련 이슈가 있어 contextualSearch 옵션을 true 로 할 경우 초기에는 검색 기능이 동작하지 않을 수 있다 - https://github.com/facebook/docusaurus/issues/6693
    - Orama 라는 대안도 존재 https://docs.askorama.ai/open-source/plugins/plugin-docusaurus
- [x] 리소스 업데이트가 빠르게 이루어지지 않는 문제
    - 커스텀 도메인 연결로 해결
- [ ] banner 를 front matter 의 image 키값을 사용해서 넣기 🛫 2024-05-06
- [ ] SEO 를 위해 모든 포스트의 front matter 에 description 정보 추가하기
    - https://www.opengraph.xyz/ 에서 확인할 수 있다
- [ ] 문서 자동 번역🛫 2024-05-07
    - [ ] github pr 을 생성하면, 특정 언어로 번역된 문서가 PR 에 포함되게 함 -> github action & DeepL
    - [ ] ~~crowdin 사용~~ 협업 툴에 가까워서 개인 블로그 용도로는 적합하지 않다고 판단

## Docusaurus 의 특징

- [[React]] 기반
- 기술 문서, 블로그 양 쪽 모두 가능
- 버전 관리, i18n 등이 갖춰져있음
- Plugin 으로 기능 확장 가능
- Markdown 뿐만 아니라 [[MDX]] 로도 문서 작성 가능

## Language

[[TypeScript]]. 굳이 JS 를 선택해야하는 이유를 못느낌.

## Package manager

docusaurus 는 [[npm]], [[yarn]], [[pnpm]] 을 모두 지원.

npm 은 너무 자주 써왔기 때문에 이번에는 pnpm 을 사용해보기로 함.

이 정도부터 `pnpm start` 명령을 통해 현재 블로그 상태를 확인할 수 있다.

```bash
pnpm start
```

## Mode

docusaurus 는 docs 와 blog 모드가 각각 존재하며, docs 는 기술 문서에 가까운 형태를 띔. 개발 블로그는 blog mode 만 있어도 충분했기 때문에 blog only 로 설정할까 고민했음. 하지만 이럴 경우 메인 랜딩 페이지가 없어지기 때문에 뭔가 아쉬웠음.

따라서 랜딩 페이지를 유지하기 위해 blog only 는 포기하고 docs 만 다른 형태로 바꿔주기로 함

## Mermaid

[[Mermaid]] 는 다이어그램을 코드로 간단하고 빠르게 그리는데 적합하여 평소에 자주 쓰던 도구다. Docusaurus 에서는 플러그인으로 지원하니 포함시켜주도록 하자.

플러그인 설치

```bash
pnpm add @docusaurus/theme-mermaid
```

```ts
const config: Config = {
    markdown: {
        mermaid: true,
    },
    themes: ['@docusaurus/theme-mermaid'],
};
```

https://docusaurus.io/docs/markdown-features/diagrams

## Latex

Katex 플러그인 설치

```bash
pnpm add remark-math@6 rehype-katex@7
```

```ts
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

const config: Config = {
  presets: [
    [
      'classic',
      {
        blog: {
          remarkPlugins: [remarkMath],
          rehypePlugins: [rehypeKatex],
        },
      },
    ],
  ],
};
```

CSS 까지 포함시켜주면 된다.

```ts
const config: Config = {
    stylesheets: [
        {
            href: 'https://cdn.jsdelivr.net/npm/katex@0.13.24/dist/katex.min.css',
            type: 'text/css',
            integrity:
                'sha384-odtC+0UGzzFL/6PNoE8rX/SPcQDXBJ+uRepguP4QkPCm2LBxH3FA3y+fKSiJ+AmM',
            crossorigin: 'anonymous',
        },
    ],
};
```

## Code block highlight

java 가 기본지원이 아니기 때문에(...!!) prism 설정을 통해 java 추가. 겸사겸사 bash 도 추가해주었음.

```ts
const config: Config = {
    themeConfig: {
        prism: {
            theme: prismThemes.github,
            darkTheme: prismThemes.dracula,
            additionalLanguages: ['java', 'bash'],
        },
    },
};
```

## Github pages 배포

배포 방법에는 여러 종류가 있지만, github 를 벗어나지 않고 한 군데에서 모두 처리하고 싶었기 때문에 [[GitHub]] pages 를 쓰기로 했다. 기본적으로 도메인도 `~.github.io` 처럼 깔끔하게 생성해주기 때문에 나쁘지 않은 옵션이다.

Github Actions 을 통해 CI/CD 를 구성해보자.

먼저 `./.github/workflows/` 에 yaml 파일을 하나 생성해준다. 내용은 아래와 같다.

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
    # Review gh actions docs if you want to further define triggers, paths, etc
    # https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on

jobs:
  build:
    name: Build Docusaurus
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: pnpm/action-setup@v3
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: pnpm

      - name: Install dependencies
        run: pnpm install
      - name: Build website
        run: pnpm run build

      - name: Upload Build Artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: build

  deploy:
    name: Deploy to GitHub Pages
    needs: build

    # Grant GITHUB_TOKEN the permissions required to make a Pages deployment
    permissions:
      pages: write # to deploy to Pages
      id-token: write # to verify the deployment originates from an appropriate source

    # Deploy to the github-pages environment
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

이후 `Settings > Pages` 에서 main/root 로 설정해주면 배포 끝. 이후는 main 브랜치에 커밋이 push 될 때마다 자동으로 배포 작업이 진행된다.

![](https://i.imgur.com/42rOiuF.png)

## 커스텀 도메인 연결하기

기본 깃허브 도메인을 써도 큰 지장은 없지만, 블로그를 이전하는 김에 도메인도 하나 구매해서 개발자 느낌 좀 내보려 한다.

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

## 추가. 도메인 verified 로 탈취 방지하기

- IP 를 추가했던 것처럼 TXT 또한 추가

![](https://i.imgur.com/PH3fifE.png)

1번이 키고 2번이 값인 느낌이다.

godaddy 로 가서 이름과 값에 위의 값들을 각각 복사해서 넣으면 된다.

![](https://i.imgur.com/eMYlw2I.png)

레코드를 추가하고 잠시 기다린 뒤 Verify 버튼을 클릭하면,

![](https://i.imgur.com/bBquRwp.png)

이렇게 도메인 인증이 완료되고 도메인 탈취 공격으로부터 보호할 수 있게 된다.

---

## Giscus 댓글

기존 컴포넌트의 디자인을 수정할 수 있다. Giscus 컴포넌트를 구현하여 추가함으로써 댓글 기능을 간단하게 구현한다.

참고: https://rikublock.dev/docs/tutorials/giscus-integration/

## tip. 폴더구조 수정

docusaurus 같은 경우 [[Jekyll]] 처럼 날짜를 파일이름에 명시하는 방법도 지원하지만, 폴더로 구성하면 리소스를 같은 폴더 안에 모아둘 수 있어서 편리하다. 글이 많은 만큼 스크립트를 작성해서 한 번에 수정해주자.

![](https://i.imgur.com/ucjhZ0G.png)

```bash
#!/bin/bash

# 모든 .md 파일에 대해 실행
for file in *.md; do
  # 파일 이름에서 날짜 추출
  date=$(echo $file | rg -o '\d{4}-\d{2}-\d{2}')

  # 해당 날짜로 디렉토리 생성 (디렉토리가 이미 존재하면 무시)
  mkdir -p "$date"

  # 파일을 해당 디렉토리로 이동
  mv "$file" "$date/"
done

# 각 디렉토리에 대해 실행
for dir in */; do
    # 출력되는 파일에서 yyyy-MM-dd 부분을 제거
    new_filename=$(ls $dir | sed "s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//g")
    mv "$dir/$(ls $dir)" "$dir/$new_filename"
done
```

![](https://i.imgur.com/B8q31Qu.png)

모든 파일이 한 번에 깔끔하게 이동한다. 이후에는 포스트에서 참조하는 리소스들을 맞는 디렉토리로 이동해주는 작업을 해주면 된다.

rg 명령으로 로컬 리소스를 참조하는 부분을 찾아보자.

![](https://i.imgur.com/YkUnVRQ.png)

이렇게 출력되는 파일의 상대경로가 있으니 저 파일들을 찾아서 옮겨주면 되겠다.

1. 각 리소스파일은 `blog/{yyyy-MM-dd}` 로 이동하면 된다.
2. 더 이상 글에서 `img` 디렉토리를 참조하지 않으므로, `![image](./resource.webp)` 처럼 `./` 형태로 수정한다.

역시 sh 을 사용하면 빠르고 쉽게 모든 링크 수정이 가능하겠다... 만, 리소스 이미지가 몇 개 안되어 수작업으로 몇 번 만져주니 끝나버려 스크립트를 작성하지 않았다.

여러분께 드리는 숙제로 남겨둔다. 😜

## 포스트 검색 색인

Algolia 대신 최근 등장한 Orama 를 사용해봤다.

- algolia: 무료버전에서는 크롤러가 일주일에 한 번만 동작하여 검색 색인을 갱신
- Orama: 배포 트리거를 감지하고 배포가 일어났을 때 색인을 갱신. openAi 를 연동한 의미론적 검색도 지원.
    - 다소 투박한 Algolia 에 비해 UI 가 예쁘다.
    - [한글이 지원되지 않는 문제](https://docs.askorama.ai/open-source/supported-languages/) 가 있어서 algolia 를 그대로 쓰기로 했다.

Algolia 는 배포할 때 자동으로 색인이 갱신되지 않는 점이 아쉬워서 Orama 를 사용해보려했으나, 한글 지원이 아직 이뤄지지 않아 메인으로 쓰기에는 부족하다고 판단되었다. 따라서 docusaurus 에서 밀어주는 Algolia 를 그대로 사용한다.

### Alogolia 검색시 아무 것도 나오지 않을 경우

docusaurus 에서 algolia 검색 api 를 사용할 경우

```json
[
  "language:en",
  [
    "docusaurus_tag:default",
    "docusaurus_tag:docs-default-3.2.1",
    "docusaurus_tag:docs-community-current",
    "docusaurus_tag:docs-docs-tests-current"
  ]
]
```

이런 파라미터를 동적으로 생성하여 함께 요청한다. 이 때 사용되는 파라미터(facets 이라고 함) 종류는 아래와 같은 것들이 있다.

- `docusaurus-tag`
- `lang`
- `language`
- `type`
- `version`

따라서 Algolia 인덱스를 생성했을 때 위 Facets 들은 **반드시 인덱스에 설정되어 있어야** 한다. 그러나 자주 이 facets 들이 설정되지 않은채로 Docsearch 인덱스가 생성되고는 한다.

Docsearch 승인을 받으면, 도큐사우루스 사용과 관련된 크롤러 설정 변경이 반영되기 전에 크롤러가 동작할 수 있기 때문. 이 때는 이미 인덱스 설정이 고정된 채라 도큐사우루스 설정이 반영되지 않는다.

해결방법은 필요한 모든 인덱스 facets 이 존재하는지 직접 확인하고, 없다면 추가해주는 것이다.

> [!warning]
> contextualSearch 를 `false` 로 하여 비활성화한다면 검색이 동작하게 되지만, 추천하지는 않는다.

![](https://i.imgur.com/57DUIyE.jpeg)

위의 facets 이 모두 있어야 한다. 나는 docusaurus-tag facets 이 표시되지 않았었기 때문에 직접 추가해주었다.

`Index > Configuration > Filtering and faceting - Facets` 에 `+ Add an Attribute` 로 누락된 속성을 추가해주자

![](https://i.imgur.com/x9qjnxI.png)

이후 검색이 잘 동작하는 것을 확인할 수 있다.

## i18n

예전부터 영어를 모국어로 쓰는 국가에서 유입되는 경우가 꽤 되기도 했고, 겸사겸사 영어 공부도 할 겸 영문 블로그를 운영해보고 싶다는 생각이 있었는데, Docusaurus 에서 i18n 국제화 기능이 지원되는 것을 확인하고 적용하기로 했다.

```bash
pnpm run write-translations --locale en
```

https://docusaurus.io/docs/i18n/tutorial

### 번역

- 한글 문서를 쓰면 영문으로 번역되게 하고 싶다.
- `title.md` 파일만 PR 에 포함된 경우, 번역하여 `/en/title.md` 파일로 PR 에 포함시키는게 가능하지 않을까?
- 기존에 만들어진 것들 중엔 유명한게 없는 것 같다.
- Sweep AI 를 활용해보려 했지만 번역을 위해 설계되지 않았다는 로그가 출력
- Github Action + Open AI or DeepL API 를 활용하면 어떨까?
- 404 page 등 몇몇 기본 페이지는 호스팅 서비스에 따라 번역된 페이지로 리다이렉트를 지원하지 않을 수 있다. github page 는 지원하지 않는다.

찾아보니 이런 github action 이 이미 존재했다 (역시)

- https://github.com/marketplace/actions/gpt-translate

OpenAI 의 유료 서비스인 api token 이 필요하지만, 이미 사용하고 있는게 있었으므로 큰 부담없이 써보기로 했다.

- https://github.com/songkg7/songkg7.github.io/pull/10/files

사용해보니 꽤나 잘 된다

## SEO

- front matter 를 rich 하게 만들기
    - Docusaurus 는 front matter 를 기반으로 meta 정보를 많이 생성한다
- https://www.opengraph.xyz/ 에서 meta 정보를 쉽게 확인할 수 있다.

## UpdateAt, UpdateBy

option 만 활성화 시켜주면 되며, 별도의 frontmatter 는 필요하지 않다.

[[git history]] 를 기반으로 update 를 판단하므로, github action 에서 clone 할 때 depth 옵션은 한 번 체크해주자. 기본값으로는 가장 마지막 커밋만 가져오기 때문이다.

## Conclusion

KPT 회고하기

- 즉흥적으로 기존 블로그를 그냥 폐쇄해버리고 새로 만드는 다소 과격한 조치를 한 것이 아쉬움
    - 기존 방문자들을 고려하면 최소한 리다이렉트 정도는 해뒀어야했다고 생각
    - URL 을 최대한 변경하지 않고 옮기려했으나, 생각대로 되지 않아 생긴 문제
- 이전 블로그 플랫폼에서는 세련되게 유지하기 어려웠던 부분들을 최대한 신경 써보자
    - ex) 디자인, 프론트엔드 기술들 적용

## Reference

- https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages
- https://rikublock.dev/docs/tutorials/giscus-integration/
- https://docusaurus.io/docs/search#algolia-troubleshooting
- https://discourse.algolia.com/t/no-results-with-docusaurus-contextual-search/19409/7
