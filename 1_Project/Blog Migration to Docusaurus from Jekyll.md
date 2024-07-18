---
title: 지킬 블로그를 도큐사우루스로 이사하기
date: 2024-05-02 16:47:00 +0900
aliases: 
tags:
  - docusaurus
  - blog
  - algolia
  - react
categories: 
updated: 2024-07-18 15:47:32 +0900
---

최근 블로그 플랫폼을 옮기는 작업을 진행했습니다. 이 과정에서 문제를 마주할 때마다 우아한 해결방법은 없을 지 고민하며 몇 자 적어두었는데, 나름 수요가 있을지도 모른다는 생각에 글로 발행해보았습니다.

## Overview

![](https://i.imgur.com/ootNbaX.png)

- 24년 4월, 갑자기 ~~세상이 무너졌~~ 블로그가 망가졌다
    - Jdelivery CDN 이슈
    - 조금 기다리면 문제가 해결되었겠으나, 그동안 쌓인 불편으로 인해 코드를 잘못 작성했나보다고 오해하게 되었다..
- [[Jekyll]] 이 자유도가 높지 않고, 유지보수의 불편 등 전체적으로 관리하기 어렵다는 느낌이 계속 들어 [[Docusaurus]] 로 마이그레이션을 시도
    - 특히 fork 를 통해 블로그를 구성하는 특성상, github 에 잔디 기록이 남지 않아 아쉬웠다
- [[O2]] 의 이슈 중 docusaurus 를 지원해달라는 이슈가 있었지만 사용해보지 않아 해결하지 못하고 있었다 - [\[FR\] support mkdocs-material, docusaurus · songkg7/o2 · Discussion #346 · GitHub](https://github.com/songkg7/o2/discussions/346)

이상의 종합적인 이유들로 블로그를 마이그레이션하기로 결정.

## Docusaurus 의 특징

- [[React]] 기반
- 기술 문서, 블로그 양 쪽 모두 가능
- 버전 관리, i18n 등이 갖춰져있음
- Plugin 으로 기능 확장 가능
- Markdown 뿐만 아니라 [[MDX]] 로도 문서 작성 가능

## Language

[[TypeScript]]. 최근 몇몇 프로젝트에서 TS 에서 벗어나려는 시도가 있었지만, 개인적으로는 공감하지 못했다. 오히려 굳이 JS 를 선택해야하는 이유를 못느끼기 때문에 TS 로 환경을 구성했다.

## Package manager

Docusaurus 는 [[npm]], [[yarn]], [[pnpm]] 을 모두 지원한다. npm 은 너무 써봤기 때문에 이번에는 pnpm 이나 yarn 중에 사용해보고자 했다.

결론만 적자면, yarn 을 선택했다. 이유는 다음과 같았다.

- pnpm 에서는 github action 을 설정할 때 마음에 들지 않는 부분이 있었음
- 결정적으로, 05.23 에 토스 기술블로그에 올라온 [패키지 매니저 관련 글](https://toss.tech/article/lightning-talks-package-manager)을 보고 [[yarn]] 으로 변경

패키지 매니저까지 선택했다면, 이제 바로 블로그를 확인해볼 수 있다.

```bash
yarn start
```

## Blog or Docs

Docusaurus 는 docs 와 blog 모드가 각각 존재하며, docs 는 기술 문서를 위한 포맷이다. 개발 블로그는 blog mode 만 있어도 충분했기 때문에 blog only 로 설정하여 docs 페이지를 제거해버릴까 고민했다. 하지만 이럴 경우 메인 랜딩 페이지가 없어지기 때문에 뭔가 아쉬웠다. 디자인할 수 있는 요소 하나가 사라지는 느낌이랄까.

고민 끝에 랜딩 페이지를 유지하기 위해 blog only 는 포기하고 docs 만 다른 형태로 바꿔주기로 했다.

## Mermaid

[[Mermaid]] 는 다이어그램을 코드로 간단하고 빠르게 그리는데 적합하여 평소에 자주 쓰는 도구다. Docusaurus 에서는 플러그인으로 지원하니 포함시켜주도록 하자.

```bash
yarn add @docusaurus/theme-mermaid
```

```ts
const config: Config = {
    markdown: {
        mermaid: true,
    },
    themes: ['@docusaurus/theme-mermaid'],
};
```

자세한 내용은 [공식 문서](https://docusaurus.io/docs/markdown-features/diagrams) 를 참고.

## Latex

가끔씩 수식을 입력해야하는 경우가 있다. 아마 데이터 엔지니어 직군이나, 수학을 많이 활용하는 직군이라면 더더욱 그런 유즈케이스가 많으리라 생각한다. 일반적으로 수식 입력에는 Latex 방식을 사용하므로 Docusaurus 에서도 사용가능하도록 설정해보자.

Docusaurus 에서는 Katex 플러그인으로 Latex 를 사용할 수 있다.

```bash
yarn add remark-math@6 rehype-katex@7
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

## Code Block Highlight

java 가 기본지원이 아니기 때문에(...?!) prism 설정을 통해 java 추가. 겸사겸사 bash 도 추가해주었다. 만약 본인이 자주 쓰는 언어가 하이라이팅되지 않는다면 적당히 추가해주면 되겠다.

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

## GitHub Pages 배포

배포 방법에는 여러 종류가 있지만, GitHub 를 벗어나지 않고 한 군데에서 모두 처리하고 싶었기 때문에 [[GitHub]] pages 를 쓰기로 했다. 기본 도메인도 `~.github.io` 처럼 깔끔하게 사용할 수 있기 때문에 나쁘지 않은 옵션이다.

블로그 글을 작성하면 자동으로 배포되도록 Github Actions 을 통해 CI/CD 를 구성해보자. 먼저 `./.github/workflows/` 에 yaml 파일을 하나 생성해준다. 내용은 아래와 같다.

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
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: yarn

      - name: Install dependencies
        run: yarn install --frozen-lockfile
      - name: Build website
        run: yarn run build

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

이후 `Settings > Pages` 에서 Source 를 `GitHub Actions` 으로 설정해주면 배포 끝. 이후는 main 브랜치에 커밋이 push 될 때마다 자동으로 배포 작업이 진행된다.

![](https://i.imgur.com/E2pWDp6.png)

> [!WARNING] Source 를 확인해주자
> 만약 Source 를 `Deploy from a branch` 로 할 경우, 배포 과정동안 블로그 서비스가 중단되는 현상이 발생할 수 있다.

## 커스텀 도메인 연결하기

기본 깃허브 도메인(~.github.io)을 써도 큰 지장은 없지만, 블로그를 이전하는 김에 도메인도 하나 구매해서 긱(Geek) 한 개발자 느낌을 좀 내보려 한다. 만약 나중에 GitHub Pages 가 아닌 다른 플랫폼을 사용하여 배포하게 되더라도, 도메인이 있다면 SEO 를 유지하기 수월할 것이다.

### 도메인 구매 및 등록

- haril.dev 도메인을 godaddy 에서 구매(연간 20$)
- GitHub Pages 에 커스텀 도메인 등록을 해줘야 한다.
- 기존 사용하던 도메인의 아이피 주소부터 확인하자.

```bash
dig songkg7.github.io
```

![](https://i.imgur.com/76RPRYC.png)

이 도메인 정보를 godaddy 레코드에 등록해주면 된다.

![](https://i.imgur.com/lUEshGu.png)

이후 깃허브 페이지 설정에 가서 구매한 도메인을 등록해주면 설정이 완료된다.

![](https://i.imgur.com/ImiE0kj.png)

## Optional. 도메인 verified 로 탈취 방지하기

- Profile Settings -> Pages
- IP 를 추가했던 것처럼 TXT 또한 추가

![](https://i.imgur.com/PH3fifE.png)

1번이 키고 2번이 값인 느낌이다. godaddy 로 가서 레코드에 위의 값들을 각각 복사해서 넣으면 된다.

![](https://i.imgur.com/eMYlw2I.png)

레코드를 추가하고 잠시 기다린 뒤 Verify 버튼을 클릭하면,

![](https://i.imgur.com/bBquRwp.png)

이렇게 도메인 인증이 완료되고 도메인 탈취 공격으로부터 보호할 수 있게 된다. ~~누가 이런 도메인을 탈취하려고 할까 싶지만...~~

## Giscus 댓글

Docusaurus 에서는 기존 컴포넌트의 디자인을 수정할 수 있다. Giscus 컴포넌트를 구현하여 추가함으로써 댓글 기능을 간단하게 구현할 수 있다.

참고: [Add Giscus Comments to Docusaurus 3 Blog Posts and Doc Pages | Riku Block](https://rikublock.dev/docs/tutorials/giscus-integration/)

## 검색 엔진

엄청나게 많은 글을 발행하는 편은 아니지만 글 목록이 한 페이지를 넘어가게 되어 스크롤이 필요하다고 느껴진 순간부터, 검색 기능이 있으면 좋겠다고 생각했다. 글들을 검색할 수 있게 인덱싱해놓는다면 제목 뿐만 아니라 글 내용으로도 검색이 가능해질 것이므로, 방문객들이 원하는 내용을 찾기가 수월할 것이다.

Docusaurus 에서 사용할 수 있는 상용 검색 엔진은 두 가지가 있다.

- Algolia
    - 무료버전에서는 크롤러가 일주일에 한 번만 동작하여 검색 색인을 갱신
    - Docusaurus 가 공식적으로 밀어주는 검색 엔진
    - 수동으로 트리거해서 색인을 갱신할 수 있다
- [Orama](https://askorama.ai/)
    - 적용이 매우 간편하다. 따로 분석이 필요하지 않다면 코드를 붙여넣는 것만으로도 적용이 끝난다.
    - 배포 트리거를 감지하고 배포가 일어났을 때 색인을 갱신
    - openAI 를 연동한 의미론적 검색도 지원
    - 다소 투박한 Algolia 에 비해 UI 가 예쁘다. 개인적으로 기능만큼 디자인을 중요하게 여긴다.

Algolia 는 배포할 때 자동으로 색인이 갱신되지 않는 점이 아쉽고, 아무래도 UI/UX 가 더 좋았던 Orama 를 적용했다.

![](https://i.imgur.com/VCp0Eee.png)

_orama 는 main 페이지도 아름답다_

하지만 곧 롤백할 수 밖에 없었는데, Orama 에서는 아직 [한글 토크나이저가 지원되지 않고 있어서](https://docs.askorama.ai/open-source/supported-languages/) 한국어 검색이 불가능했다 😭. 메인 타겟층이 국내인 이상, 한국어 검색은 필수적이므로 아쉽지만 Algolia 를 사용하기로 했다.

### Algolia 검색시 아무 것도 나오지 않을 경우

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

이런 파라미터를 동적으로 생성하여 함께 요청한다. 이 때 사용되는 파라미터는 일종의 필터로, 검색엔진에서는 facets 이라고 하며 종류는 아래와 같은 것들이 있다.

- `docusaurus-tag`
- `lang`
- `language`
- `type`
- `version`

따라서 Algolia 인덱스를 생성했을 때 위 facets 들은 **반드시 인덱스에 설정되어 있어야** 한다. 그러나 자주 이 facets 들이 설정되지 않은채로 DocSearch 인덱스가 생성되고는 한다.

DocSearch 승인을 받으면, 도큐사우루스 사용과 관련된 크롤러 설정 변경이 반영되기 전에 크롤러가 동작할 수 있기 때문. 이 때는 이미 인덱스 설정이 고정된 채라 도큐사우루스 설정이 반영되지 않는다.

해결방법은 필요한 모든 인덱스 facets 이 존재하는지 직접 확인하고, 없다면 추가해주는 것이다.

> [!warning]
> contextualSearch 를 `false` 로 하여 비활성화한다면 검색이 동작하게 되지만, 추천하지는 않는다.

![](https://i.imgur.com/57DUIyE.jpeg)

위의 facets 이 모두 있어야 한다. 나는 `docusaurus_tag` facets 이 표시되지 않았었기 때문에 직접 추가해주었다.

`Index > Configuration > Filtering and faceting - Facets` 의 `+ Add an Attribute` 로 누락된 속성을 추가해줄 수 있다.

![](https://i.imgur.com/x9qjnxI.png)

이후 검색이 잘 동작하는 것을 확인할 수 있다.

![](https://i.imgur.com/XPVw3UJ.png)

### 글 작성 직후 인덱스 갱신에도 불구하고 검색되지 않는 문제

- 새로운 글을 포스팅한 뒤 수동으로 크롤러를 트리거하여 인덱스를 갱신했지만 검색되지 않고 있다.
- Algolia 인덱스에 직접 접근하여 쿼리해보면 새 글이 제대로 검색된다.
- local 에서 contextualSearch 를 false 로 해도 검색되지 않았다.
- API 를 사용할 때만 검색되지 않는 듯하다.
- API 파라미터를 조사해볼 필요가 있겠다.
- 크롤링을 다시 트리거한 직후에는 검색 결과가 정상적이였지만, 새 창을 열어서 테스트하니 다시 이전 버전의 검색 결과가 등장했다.
- DSN(distributed search network) 라는 기술을 활용 중인데 분산되어 있는 환경에 의해 갱신된 인덱스가 화면에 바로 반영이 되지 않는 것인지 의심된다.
- 하루 정도 지나니 정상적으로 반영되었다.

## i18n

예전부터 영어를 모국어로 쓰는 국가에서 유저가 유입되는 경우가 꽤 되기도 했고, 겸사겸사 영어 공부도 할 겸 영문 블로그를 운영해보고 싶다는 생각이 있었는데, Docusaurus 에서는 i18n 국제화 기능이 지원되기 때문에 적용하기로 했다.

```bash
yarn run write-translations --locale en
```

[Docusaurus](https://docusaurus.io/docs/i18n/tutorial)

이제 문제는 문서 번역 작업이다.

### 번역을 수작업...?

- 한글 문서를 쓰면 영문으로 번역되게 하고 싶다.
- `title.md` 파일만 PR 에 포함된 경우, 번역하여 `/en/title.md` 파일로 PR 에 포함시키는게 가능하지 않을까?
- 기존에 만들어진 것들 중엔 유명한게 없는 것 같다.
- Sweep AI 를 활용해보려 했지만 번역을 위해 설계되지 않았다는 로그가 출력
- Github Action + Open AI or DeepL API 를 활용하면 어떨까?
- 404 page 등 몇몇 기본 페이지는 호스팅 서비스에 따라 번역된 페이지로 리다이렉트를 지원하지 않을 수 있다. github page 는 지원하지 않는다.

찾아보니 이런 github action 이 이미 존재했다 (역시 사람 생각은 다 비슷한가보다)

- [GPT Translate · Actions · GitHub Marketplace · GitHub](https://github.com/marketplace/actions/gpt-translate)

OpenAI 의 유료 서비스인 api token 이 필요하지만, 이미 사용하고 있는게 있었으므로 큰 부담없이 써보기로 했다.

- [🌐 Add LLM Translations by github-actions\[bot\] · Pull Request #10 · songkg7/haril.dev · GitHub](https://github.com/songkg7/songkg7.github.io/pull/10/files)

사용해보니 꽤나 잘 된다. 개인적으로 일본어도 공부하고 있기 때문에, 앞으로 글을 작성하면 영어와 일본어로 번역한 뒤 퇴고 작업을 거치며 컨텐츠를 제공할 예정이다.

## SEO

- front matter 를 rich 하게 만들기
    - Docusaurus 는 front matter 를 기반으로 meta 정보를 생성한다
-  [OpenGraph](https://www.opengraph.xyz/)에서 meta 정보를 쉽게 확인할 수 있다.

## UpdateAt and UpdateBy

option 만 활성화 시켜주면 되며, 별도의 frontmatter 는 필요하지 않다.

[[git history]] 를 기반으로 update 를 판단하므로, github action 에서 clone 할 때 depth 옵션은 한 번 체크해주자. 기본값으로는 가장 마지막 커밋만 가져오기 때문이다.

updateBy 는 적용해봤다가 롤백했는데,

- 자동화 시켜놓은 몇몇 작업에서 github action 이 수정자로 표시되는 현상이 마음에 들지 않았고,
- edit 버튼을 노출시킴으로써 협업을 지향하고는 있지만, 실제로 PR 이 많이 생성되지는 않을 것 같았기 때문이다.

당장은 updateAt 만 있어도 충분할 것 같다.

## Migration Tip. 폴더구조 수정

![](https://i.imgur.com/ucjhZ0G.png)

_기존 디렉토리 구조. `_posts` 폴더 아래에 markdown 문서가 한 번에 들어있다._

Docusaurus 같은 경우 [[Jekyll]] 처럼 날짜를 파일이름에 명시하는 방법도 지원하지만, 폴더로 구성하면 이미지 등의 리소스들을 같은 폴더 안에 모아둘 수 있어서 편리하다. 글이 많은 만큼 [[shell]] 스크립트를 작성해서 한 번에 수정해주자.

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

`ripgrep` 명령으로 로컬 리소스를 참조하는 부분을 찾아보자.

![](https://i.imgur.com/YkUnVRQ.png)

이렇게 출력되는 파일의 상대경로가 있으니 저 파일들을 찾아서 옮겨주면 되겠다.

1. 각 리소스파일은 `blog/{yyyy-MM-dd}` 로 이동하면 된다.
2. 더 이상 글에서 `img` 디렉토리를 참조하지 않으므로, `![image](./resource.webp)` 처럼 `./` 형태로 수정한다.

역시 sh 을 사용하면 빠르고 쉽게 모든 링크 수정이 가능하겠다... 만, 리소스 이미지가 몇 개 안되어 수작업으로 몇 번 만져주니 끝나버려 스크립트를 작성하지 않았다.

여러분께 드리는 숙제로 남겨둔다. 😜 (GPT 선생님께 여쭤보면 이 정도는 순식간이다)

## Image alt-text

- 이미지의 대체 텍스트는 번거로워서 잘 신경쓰지 않았었는데, 시각 장애인처럼 특수한 점자 리더기를 사용하는 등의 접근 편의성이 필요한 사람들에게 이미지 대신 제공될 수 있는 텍스트라고 한다.
- 이 사실을 알게 된 이후로, 대체 텍스트를 신경써야겠다는 생각을 하게 되었다.
- 깃허브에서 관련 워크플로우를 추가했다고 하니 살펴볼만하다.
    - [GitHub - github/accessibility-alt-text-bot: An action to remind users to add alt text on Issues, Pull Requests, and Discussions](https://github.com/github/accessibility-alt-text-bot)

## Conclusion

짧게 KPT 회고를 적어본다.

- 즉흥적으로 기존 블로그를 그냥 폐쇄해버리고 새로 만드는 다소 과격한 조치를 한 것이 아쉬움
    - 기존 방문자들을 고려하면 최소한 리다이렉트 정도는 해뒀어야했다고 생각
    - URL 을 최대한 변경하지 않고 옮기려했으나, 생각대로 되지 않아 생긴 문제
- 리다이렉트 조치를 하지 못한 것이 뼈아픈 실책. 유입경로를 보면 꾸준히 not found 가 찍히고 있음
- 이전 블로그 플랫폼에서는 세련되게 유지하기 어려웠던 부분들을 최대한 신경 써보자
    - ex) 디자인, 프론트엔드 기술들 적용

## Reference

- [About custom domains and GitHub Pages - GitHub Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages)
- [Add Giscus Comments to Docusaurus 3 Blog Posts and Doc Pages | Riku Block](https://rikublock.dev/docs/tutorials/giscus-integration/)
- [Docusaurus](https://docusaurus.io/docs/search#algolia-troubleshooting)
- [No results with Docusaurus contextual search - Open Q&A - Algolia Community](https://discourse.algolia.com/t/no-results-with-docusaurus-contextual-search/19409/7)
